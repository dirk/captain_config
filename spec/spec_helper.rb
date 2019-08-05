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

  config.before :suite do
    tmp = File.expand_path('../../tmp', __FILE__)
    FileUtils.makedirs tmp

    database = File.join(tmp, 'test.sqlite3')
    FileUtils.safe_unlink database

    CaptainConfig::BaseConfig.tap do |base|
      base.establish_connection(
        adapter: 'sqlite3',
        database: database,
      )

      # Easier than bothering with migrations (and migrations are already
      # checked by the integration setup Rakefile and tests).
      base.connection.execute <<-SQL
        CREATE TABLE 'captain_configs' (
          'id' integer PRIMARY KEY AUTOINCREMENT NOT NULL,
          'type' varchar NOT NULL,
          'key' varchar NOT NULL,
          'text' varchar,
          'created_at' datetime NOT NULL,
          'updated_at' datetime NOT NULL
        );
      SQL
    end
  end
end
