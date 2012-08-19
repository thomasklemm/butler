require 'rack/utils'
require 'active_support/core_ext/uri'
require 'butler/asset'

module Butler
  #
  # Butler::Handler
  #
  # The link between Butler::Static and Butler::Asset
  # Transforms HTTP header rules into actual HTTP headers
  # for a single file to be set by Butler::Asset
  #
  # Code adapted from Rails' ActionDispatch::FileHandler
  #
  class Handler
    def initialize(root, options={})
      @root          = root.chomp('/')
      @compiled_root = /^#{Regexp.escape(root)}/
      @headers       = {}
      @header_rules  = options[:header_rules] || {}
      @file_server   = Butler::Asset.new(@root, headers: @headers)
    end

    def match?(path)
      path = path.dup

      full_path = path.empty? ? @root : File.join(@root,
        escape_glob_chars(unescape_path(path)))
      paths = "#{full_path}#{ext}"

      matches = Dir[paths]
      match = matches.detect { |m| File.file?(m) }
      if match
        match.sub!(@compiled_root, '')
        ::Rack::Utils.escape(match)
      end
    end

    def call(env)
      @path = env['PATH_INFO']
      set_headers
      @file_server.call(env)
    end

    def ext
      @ext ||= begin
        ext = ::ActionController::Base.page_cache_extension
        "{,#{ext},/index#{ext}}"
      end
    end

    def unescape_path(path)
      URI.parser.unescape(path)
    end

    def escape_glob_chars(path)
      path.force_encoding('binary') if path.respond_to? :force_encoding
      path.gsub(/[*?{}\[\]]/, "\\\\\\&")
    end

    # Convert header rules to headers
    def set_headers
      @header_rules.each do |rule, result|
        case rule
        when :global
          set_header(result)
        when :fonts
          set_header(result) if @path.match(%r{\.(?:ttf|otf|eot|woff|svg)\z})
        when Regexp
          set_header(result) if @path.match(rule)
        when Array
          # Extensions
          extensions = rule.join('|')
          set_header(result) if @path.match(%r{\.(#{extensions})\z})
        when String
          # Folder
          path = ::Rack::Utils.unescape(@path)
          set_header(result) if
            (path.start_with?(rule) || path.start_with?('/' + rule))
        else
        end
      end
    end

    def set_header(result)
      result.each do |field, content|
        @headers[field] = content
      end
    end

  end
end