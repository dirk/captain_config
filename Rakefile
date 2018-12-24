require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :spec do
  namespace :setup do
    desc 'Set up sample application'
    task :sample do
      def shell(command)
        system({ 'BUNDLE_GEMFILE' => nil }, command)
        if $?.exitstatus != 0
          $stderr.puts "Command failed: #{command}"
          exit $?.exitstatus
        end
      end

      # Clear out any previously-built sample application.
      shell 'rm -rf spec/sample'

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
  end
end
