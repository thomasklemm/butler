require 'rack/utils'
require 'active_support/core_ext/uri'

require 'file_handler'

module Server
  def initialize(app, path, options={})
    @app = app
    @header_rules = options[:header_rules] || {}
    @file_handler = Servely::FileHandler.new(path, header_rules: @header_rules)
  end

  def call(env)
    case env['REQUEST_METHOD']
    when 'GET', 'HEAD'
      path = env['PATH_INFO'].chomp('/')
      if match = @file_handler.match?(path)
        env["PATH_INFO"] = match
        return @file_handler.call(env)
      end
    end

    @app.call(env)
  end
end