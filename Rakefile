require 'bundler/gem_tasks'
require 'active_support/core_ext/string'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :spec do
  namespace :setup do
    def shell(command)
      system({ 'BUNDLE_GEMFILE' => nil }, command)
      if $?.exitstatus != 0
        $stderr.puts "Command failed: #{command}"
        exit $?.exitstatus
      end
    end

    root = 'spec/sample'

    gemfile = "#{root}/Gemfile"
    controller = "#{root}/app/controllers/configs_controller.rb"
    routes = "#{root}/config/routes.rb"
    initializer = "#{root}/config/initializers/config_service.rb"

    desc 'Set up sample application'
    task sample: [
      gemfile,
      controller,
      initializer,
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

      shell 'bundle exec rails new spec/sample ' \
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
        '--skip-turbolinks'

      File.open('spec/sample/Gemfile', 'a') do |file|
        file.write "gem 'captain_config', path: '../..'\n"
      end

      shell 'sh -c "cd spec/sample && ' \
        'bundle install && ' \
        'rails generate captain_config && ' \
        'rake db:migrate' \
        '"'
    end

    file controller do |task|
      source = <<-RUBY
        class ConfigsController < ApplicationController
          def show
            render text: CONFIG[params[:id].to_sym]
          end

          def update
            new_value = (CONFIG[params[:id].to_sym] = params[:value])
            render text: new_value
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
