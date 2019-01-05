require 'rails/generators/active_record/migration'

class ConfigCaptainGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  desc "Creates the migration for the `config_captains' table."

  def create_config_captains_migration
    migration_template 'create_captains_configs.rb.tt', "#{db_migrate_path}/create_captains_configs.rb"
  end
end
