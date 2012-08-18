require 'bundler/gem_tasks'

# Tests
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

# Alias default task to test
task default: :test