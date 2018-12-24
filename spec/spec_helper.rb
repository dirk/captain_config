require 'bundler/setup'
require 'httparty'
require 'pry'
require 'wait_for_it'

require 'captain_config'

require_relative 'support/shell'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
