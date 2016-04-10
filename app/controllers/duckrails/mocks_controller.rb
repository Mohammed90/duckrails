require 'duckrails/router'
require 'libxml'

module Duckrails
  class MocksController < ApplicationController
    before_action :load_mock, only: [:edit, :update, :destroy]
    after_action :reload_routes, only: [:update, :create, :destroy]

    skip_before_action :verify_authenticity_token, :only => [:serve_mock]

    def index
      @mocks = Duckrails::Mock.page params[:page]
    end

    def edit
    end

    def new
      @mock = Duckrails::Mock.new
    end

    def update
      @mock.assign_attributes mock_params

      if @mock.save
        redirect_to duckrails_mocks_path, flash: { info: 'The mock was successfully updated.' }
      else
        @skip_reloading = true
        render :edit
      end
    end

    def create
      @mock = Duckrails::Mock.new mock_params

      if @mock.save
        redirect_to duckrails_mocks_path, flash: { info: 'The mock was created successfully.' }
      else
        @skip_reloading = true
        render :new
      end
    end

    def destroy
      @mock.delete
      Duckrails::Router.unregister_mock @mock
      redirect_to duckrails_mocks_path, flash: { info: "Mock '#{@mock.name}' was deleted successfully." }
    end

    # This is the one and only action mapped to each mock route
    def serve_mock
      mock = Duckrails::Mock.find params[:duckrails_mock_id]
      overrides = (evaluate_content(mock.script_type, mock.script, true) || {}).with_indifferent_access

      mock.headers.each do |header|
        add_response_header header
      end

      if overrides[:headers]
        overrides[:headers].each do |header|
          add_response_header header
        end
      end

      status = overrides[:status_code] || mock.status
      content_type = overrides[:content_type] || mock.content_type
      body = overrides[:body] || evaluate_content(mock.body_type, mock.body_content)

      render body: body, content_type: content_type, status: status
    end

    #########
    protected
    #########

    def add_response_header(header)
      response.headers[header[:name]] = header[:value]
    end

    def evaluate_content(script_type, script, force_json = false)
      return nil unless script_type.present?

      result = case script_type
        when Duckrails::Mock::SCRIPT_TYPE_STATIC
          script
        when Duckrails::Mock::SCRIPT_TYPE_EMBEDDED_RUBY
          context_variables = {
            response: response,
            request: request,
            parameters: params
          }

          Erubis::Eruby.new(script).evaluate(context_variables)
        when Duckrails::Mock::SCRIPT_TYPE_JS
          headers = request.headers.select do |header|
            header[1].is_a? String
          end
          context = ExecJS.compile("parameters = #{params.to_json}; headers = #{headers.to_json}")
          context.exec script
      end unless script.blank?

      force_json ? JSON.parse(result.blank? ? '{}' : result) : result
    rescue StandardError => error
      response.headers['Duckrails-Error'] = error.to_s
      logger.error error.message
      logger.error error.backtrace.join "\n"
      nil
    end

    def reload_routes
      Duckrails::Application.routes_reloader.reload! unless @skip_reloading
    end

    def mock_params
      params.require(:duckrails_mock).permit(:name,
                                             :description,
                                             :status,
                                             :body_type,
                                             :body_content,
                                             :script_type,
                                             :script,
                                             :request_method,
                                             :content_type,
                                             :route_path,
                                             headers_attributes: [:id,
                                                                  :name,
                                                                  :value,
                                                                  :_destroy])
    end

    def load_mock
      @mock = Duckrails::Mock.find params[:id]
    end
  end
end
