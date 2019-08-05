require 'spec_helper'

RSpec.describe 'Integration' do
  include CaptainConfig::Shell

  around(:all) do |all|
    Dir.chdir('spec/sample') do
      shell 'sqlite3 db/development.sqlite3 "DELETE FROM captain_configs;"'

      env = {
        'RAILS_ENV' => 'development',
      }
      CaptainConfig::Shell::UNSET_VARIABLES.each do |variable|
        env[variable] = nil
      end

      # Can use this again once the following PR is merged and a new gem
      # version cut:
      #   https://github.com/schneems/wait_for_it/pull/3
      #
      # WaitForIt.new(
      #   'bundle exec puma',
      #   env: env,
      #   wait_for: 'Listening on',
      # ) do
      #   all.run
      # end

      begin
        pid = Process.spawn env, 'bundle', 'exec', 'puma'
        sleep 2
        all.run
      ensure
        Process.kill('TERM', pid)
        Process.wait(pid)
      end
    end
  end

  let(:host) { 'http://localhost:3000' }

  it 'reads and writes values' do
    # It should start off as false.
    expect(HTTParty.get("#{host}/configs/some_boolean").body).to eq 'false'

    # Then set it to true.
    expect(
      HTTParty.patch(
        "#{host}/configs/some_boolean",
        body: { value: 'true' },
      ).body,
    ).to eq 'true'

    # And it should still be true.
    expect(HTTParty.get("#{host}/configs/some_boolean").body).to eq 'true'
  end
end
