# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'butler/version'

Gem::Specification.new do |gem|
  gem.name          = "butler_static"
  gem.version       = Butler::VERSION
  gem.authors       = ["Thomas Klemm"]
  gem.email         = ["github@tklemm.eu"]
  gem.description   = "Butler is a Rack Middleware that serves static assets for your Rails app."
  gem.summary       = "Butler is a Rack Middleware that serves static assets for your Rails app. It allows you to set HTTP headers for individual files or folders based on rules."
  gem.homepage      = "https://github.com/thomasklemm/butler"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Dependencies
  gem.add_dependency 'rack'

  # Tests
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'guard-minitest'
  gem.add_development_dependency 'turn'
  # Only ActiveSupport and ActionController nescessary
  # gem.add_development_dependency 'rails', '~> 3.2.8'
  gem.add_development_dependency 'activesupport', '~> 3.2.8'
  gem.add_development_dependency 'actionpack', '~> 3.2.8'
end
