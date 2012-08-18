# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'servely/version'

Gem::Specification.new do |gem|
  gem.name          = "servely"
  gem.version       = Servely::VERSION
  gem.authors       = ["Thomas Klemm"]
  gem.email         = ["github@tklemm.eu"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

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
  gem.add_development_dependency 'rails', '~> 3.2.8'
end
