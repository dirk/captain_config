require 'rails/generators/active_record/migration'

class CaptainConfigGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  desc "Creates the migration for the `captain_configs' table."

  def create_captain_configs_migration
    migration_template 'create_captain_configs.rb.tt', "#{db_migrate_path}/create_captain_configs.rb"
  end
end
