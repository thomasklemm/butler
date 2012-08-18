# Gem
require 'bundler/gem_tasks'

# Tests
require 'guard'
task :test do
  Guard.setup
  Guard.guards('minitest').run_all
end

# Alias default task to test
task default: :test