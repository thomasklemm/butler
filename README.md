# Butler

Butler is a Rack Web Server for Static Files based on ActionDispatch::Static.
It is intended to be used as a Rails Middleware in an environment where serving static assets through a specialized web server such as nginx is technically not an option.

### Background

Butler extends ActionDispatch::Static's functionality to allow a the developer to set custom rules for the HTTP headers that the files sent should carry.

The author's intent was to allow Rails to serve static assets with custom HTTP Headers.
This allows for example serving webfonts or icon fonts carrying the appropriate HTTP headers via a Content Delivery Network (CDN) such as Amazon's Cloudfront. Files requested by the CDN will need to carry the headers the file should be sent with to the visitor's browser already when being sent from the web server.

ActionDispatch::Static, Rack::Static et al. don't allow (yet) to add custom HTTP headers to files because the underlying Rack::File implementation only allows for setting a static 'Cache-Control' header.

Code and Tests taken from Rails' ActionDispatch::Static.

If no matching file can be found in the precompiled assets the request will bubble up to the Rails stack to decide how to handle it, which mimicks ActionDispatch::Static's behaviour.

## Installation

Add this line to your application's Gemfile:

    gem 'butler_static'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install butler_static

## Usage

<!-- ### Configuration

```ruby
# config/environment/production.rb

# Use Butler
# to serve precompiled assets
config.assets.use_butler = true

# Rules for HTTP Headers to be set on files
# sent by Butler
config.assets.header_rules = {
  rule => {http_field => content},
  rule => {http_field => content}
}
``` -->

### Integration & Configuration in a Rails environment

Tell Rails where to insert Butler in the middleware stack and see if it is working(`$ rake middleware`).

```ruby
# config/environment/production.rb

# Butler Config
require 'butler'
config.butler = ActiveSupport::OrderedOptions.new # enable namespaced configuration
config.butler.enable_butler = true
config.butler.header_rules = {
  :global => {'Cache-Control' => 'public, max-age=31536000'},
  :fonts  => {'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'GET, PUT, DELETE',
      'Access-Control-Allow-Headers' => 'Origin, Accept, Content-Type'}
}

# Use Butler
enable_butler = config.butler.enable_butler
path = config.paths['public'].first
options = {}
options[:header_rules] = config.butler.header_rules

if enable_butler
  config.middleware.delete ActionDispatch::Static # delete ActionDispatch::Static when deploying to Heroku
  config.middleware.insert_before Rack::Cache, ::Butler::Static, path, options
end
```

### Providing Rules for setting HTTP Headers

There are a few way to set rules for all files or files in a certain folder or a certain extension.

```ruby
  # 1) Global Rules
  :global => Matches every file
  Ex.: :global => {
        'Cache-Control' => 'public, max-age=31536000', # 1 year
        'Some Custom Header' => 'Some Custom Content'
      }

  # 2) Folders
  '/folder' => Matches all files in a certain folder
  '/folder/subfolder' => ...
    Note: Provide the folder as a string,
         with or without the starting slash
  Ex.: '/fonts' => {'Access-Control-Allow-Origin' => '*'}

  # 3) File Extensions
  ['css', 'js'] => Will match all files ending in .css or .js
  %w(css js) => ...
    Note: Provide the file extensions in an array,
         use any ruby syntax you like to set that array up
  Ex.: %w(eot ttf otf woff svg) => {... => ...}

  # 4) Regular Expressions / Regexp
  %r{\.(?:css|js)\z} => will match all files ending in .css or .js
  /\.(?:eot|ttf|otf|woff|svg)\z/ => will match all files ending
    in the most common web font formats

  # 5) Shortcuts
  There is currently only one shortcut defined.
  :fonts => will match all files ending in eot, ttf, otf, woff, svg
    using the Regexp stated above
  Ex.: :fonts => {'Access-Control-Allow-Origin' => '*'} # Will allow fonts and icon fonts to be displayed in Firefox 3.5+


  Note: The rules will be applied in the order the are listed,
       thus more special rules further down below can override
       general global HTTP header settings
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Improve Butler
3a. Run tests continually (`bundle exec guard start`) or manually every time (`rake test`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Thanks

That's it. I hope you like Butler.
Shoot me an [email](github@tklemm.eu) or [tweet](https://www.twitter.com/thomasjklemm) if you have any questions or thoughts about how to improve Butler. Enjoy your life!
