require 'bundler/gem_tasks'
require 'active_support/core_ext/string'
require 'rspec/core/rake_task'

require_relative 'spec/support/shell'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :spec do
  namespace :setup do
    include CaptainConfig::Shell

    root = 'spec/sample'

    gemfile = "#{root}/Gemfile"
    controller = "#{root}/app/controllers/configs_controller.rb"
    initializer = "#{root}/config/initializers/config_service.rb"
    rackup = "#{root}/config.ru"
    routes = "#{root}/config/routes.rb"

    desc 'Set up sample application'
    task sample: [
      gemfile,
      controller,
      initializer,
      rackup,
      routes,
    ]

    namespace :sample do
      desc 'Teardown the sample application'
      task :clean do
        # Clear out any previously-built sample application.
        shell 'rm -rf spec/sample'
      end
    end

    file gemfile do
      Rake::Task['spec:setup:sample:clean'].invoke

      unsets = "unset #{CaptainConfig::Shell::UNSET_VARIABLES.join(' ')}"

      shell "sh -c \"#{unsets} && gem install rails\""

      shell 'sh -c "' \
        "#{unsets} && " \
        'bundle exec rails new spec/sample ' \
        '--database=sqlite3 ' \
        '--skip-git ' \
        '--skip-keeps ' \
        '--skip-yarn ' \
        '--skip-action-cable ' \
        '--skip-action-mailer ' \
        '--skip-active-storage ' \
        '--skip-bootsnap ' \
        '--skip-coffee ' \
        '--skip-javascript ' \
        '--skip-spring ' \
        '--skip-sprockets ' \
        '--skip-system-test ' \
        '--skip-test ' \
        '--skip-turbolinks ' \
        '--skip-bundle' \
        '"'

      File.open('spec/sample/Gemfile', 'a') do |file|
        file.write "gem 'captain_config', path: '../..'\n"
      end

      [
        'bundle install --jobs=3 --retry=3',
        'bundle exec rails generate captain_config',
        'RAILS_ENV=development bundle exec rake db:migrate',
        'rm config.ru config/routes.rb',
      ].each do |command|
        shell 'sh -c "' \
          'cd spec/sample && ' \
          "#{unsets} && " \
          "#{command}" \
          '"'
      end
    end

    file controller do |task|
      source = <<-RUBY
        class ConfigsController < ApplicationController
          skip_before_action :verify_authenticity_token

          def show
            render plain: CONFIG[params[:id].to_sym]
          end

          def update
            new_value = CONFIG.set(params[:id].to_sym, params[:value], coerce: true)
            render plain: new_value
          end
        end
      RUBY
      File.write task.name, source.strip_heredoc
    end

    file initializer do |task|
      source = <<-RUBY
        CONFIG = CaptainConfig::Service.new do
          some_boolean :boolean, default: false
        end
      RUBY
      File.write task.name, source.strip_heredoc
    end

    file rackup do |task|
      source = <<-RUBY
        require_relative 'config/environment'

        use CaptainConfig::PumaMiddleware

        run Rails.application
      RUBY
      File.write task.name, source.strip_heredoc
    end

    file routes do |task|
      source = <<-RUBY
        Rails.application.routes.draw do
          resources :configs, only: [:show, :update]
        end
      RUBY
      File.write task.name, source.strip_heredoc
    end
  end
end
