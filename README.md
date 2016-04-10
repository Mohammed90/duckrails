# DuckRails [![GitHub version](https://badge.fury.io/gh/iridakos%2Fduckrails.png?a=1)](https://badge.fury.io/gh/iridakos%2Fduckrails?a=1) [![Build Status](https://travis-ci.org/iridakos/duckrails.svg?branch=master)](https://travis-ci.org/iridakos/duckrails)

DuckRails is a development tool.

Its main purpose is to allow developers to quickly mock API endpoints that for many possible reasons can't reach at a specific time.

> If it looks like a duck, walks like a duck and quacks like a duck, then it's a duck

![Home Page](http://i.imgur.com/3hm0Gaj.png)

## How it works

The application allows to create new routes dynamically to which developers can assign static or dynamic responses:

- body
- headers
- content type
- status code

or even cause delays, timeouts etc.

### Guides

You can find DuckRails' guides [here](http://www.arubystory.com/p/duckrails-tutorial.html).

### Example

Setting general mock properties

![General mock properties](http://i.imgur.com/6fsHl1e.png)

Defining the response body

![Defining the response body](http://i.imgur.com/Sa6wern.png)

Setting response headers

![Setting response headers](http://i.imgur.com/ql2UR0f.png)

Setting some advanced configuration (delays, dynamic headers, content type & status)

![Advanced configuration](http://i.imgur.com/wXNVULN.png)

Upon save the route is becoming available to the application and you can use the endpoint:

![Request](http://i.imgur.com/NaCIqs9.png)
![Headers](http://i.imgur.com/1jZciKH.png)

### Embedded ruby

When specifying dynamic content of embedded ruby (more options to be added), you can read as local variables:

- <code>@parameters</code>: The parameters of the request
- <code>@request</code>: The request
- <code>@response</code>: The response

### Javascript

When specifying dynamic content of javascript type, you can read as local variables:

- <code>parameters</code>: The parameters of the request
- <code>headers</code>: The request headers

The script should always return a string (for JSON use <code>JSON.stringify(your_variable)</code>)

### Route paths

You can specify routes and access their parts in the *@parameters* variable, for example:

<pre><code>/authors/:author_id/posts/:post_id</code></pre>

give you access to the parameters with:

<pre><code>@parameters[:author_id]
@parameters[:post_id]</code></pre>

## Quick setup (development environment)

* Clone the repository.
* Execute <code>bundle install</code> to install the required gems.
* Execute <code>rake db:setup</code> to setup the database.
* Execute <code>rails server</code> to start the application on the default port.

## Better setup (production environment)
* Clone the repository.
* Execute <code>bundle install</code> to install the required gems.
* Export an env variable for your [secret key base](http://stackoverflow.com/questions/23726110/missing-production-secret-key-base-in-rails): <code>export SECRET_KEY_BASE="your_secret_key_base_here"</code>
* Execute <code>RAILS_ENV=production rake db:setup</code> to setup the database.
* Execute <code>RAILS_ENV=production rake assets:precompile</code> to generate the assets.
* Execute <code>bundle exec rails s -e production</code> to start the application on the default port.

## Database configuration

The application is by default configured to use MySQL. If you want to use another configuration, update the <code>config/database.yml</code> accordingly to match your setup.

## Contributing

1. Fork it ( https://github.com/iridakos/duckrails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This application is open source under the [MIT License](https://opensource.org/licenses/MIT) terms.
