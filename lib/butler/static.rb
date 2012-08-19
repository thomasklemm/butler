require 'rack/utils'
require 'butler/handler'

module Butler
  #
  # Butler::Static
  #
  # is a Static Web Server based on ActionDispatch::Static.
  # It is intended to be used with Rails in an environment
  # where serving static assets through a specialized web
  # server such as nginx is technically not an option.
  #
  # Butler::Static extends ActionDispatch::Static's func-
  # tionality to allow a the developer to set custom rules
  # for the HTTP headers that the files sent should carry.
  #
  # The author's intent was to allow Rails to serve static
  # assets with custom HTTP Headers.
  # This allows for example serving webfonts or icon fonts
  # carrying the appropriate HTTP headers via a Content
  # Delivery Network (CDN) such as Amazon's Cloudfront.
  # Files requested by the CDN will need to carry the headers
  # the file should be sent with to the visitor's browser
  # already when being sent from the web server.
  #
  # ActionDispatch::Static, Rack::Static et al. don't allow
  # (yet) to add custom HTTP headers to files because the
  # underlying Rack::File implementation only allows for
  # setting a static 'Cache-Control' header.
  #
  # Code adapted from Rails' ActionDispatch::Static.
  #
  # If no matching file can be found in the precompiled assets
  # the request will bubble up to the Rails stack to decide
  # how to handle it
  #
  # Usage:
  #  config.middleware.delete ActionDispatch::Static
  #  config.middleware.insert_before Rack::Cache, Butler::Static
  #
  #  # Provide the header rules like so
  #  config.assets.header_rules = {
  #    rule         => { header_field => content },
  #    another_rule => { header_field => content }
  #  }
  #
  #  # These rules are shipped along
  #  # 1) Global
  #  :global => Matches every file
  #
  #  # 2) Folders
  #  '/folder' => Matches all files in a certain folder
  #  '/folder/subfolder' => ...
  #    Note: Provide the folder as a string,
  #          with or without the starting slash
  #
  #  # 3) File Extensions
  #  ['css', 'js'] => Will match all files ending in .css or .js
  #  %w(css js) => ...
  #    Note: Provide the file extensions in an array,
  #          use any ruby syntax you like to set that array up
  #
  #  # 4) Regular Expressions / Regexp
  #  %r{\.(?:css|js)\z} => will match all files ending in .css or .js
  #  /\.(?:eot|ttf|otf|woff|svg)\z/ => will match all files ending
  #     in the most common web font formats
  #
  #  # 5) Shortcuts
  #  There is currently only one shortcut defined.
  #  :fonts => will match all files ending in eot, ttf, otf, woff, svg
  #     using the Regexp stated above
  #
  #  Note: The rules will be applied in the order the are listed,
  #        thus more special rules further down below can override
  #        general global HTTP header settings
  #
  class Static
    def initialize(app, path=nil, options={})
      @app = app
      path ||= Rails.application.config.paths['public'].first if defined? Rails
      header_rules = {}
      header_rules = Rails.application.config.assets.header_rules if defined? Rails
      header_rules = options[:header_rules] if options[:header_rules]
      @file_handler = Butler::Handler.new(path, header_rules: header_rules)
    end

    def call(env)
      case env['REQUEST_METHOD']
      when 'GET', 'HEAD'
        path = env['PATH_INFO'].chomp('/')
        if match = @file_handler.match?(path)
          env['PATH_INFO'] = match
          return @file_handler.call(env)
        end
      end

      @app.call(env)
    end
  end
end