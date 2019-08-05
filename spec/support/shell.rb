module CaptainConfig::Shell
  # Travis and Bundler set environment variables which make it impossible to
  # install or run a Rails application inside the project directory. These are
  # the environment variables that we need to unset to make it possible.
  UNSET_VARIABLES = %w[
    BUNDLE_GEMFILE
    BUNDLE_PATH
    GEM_HOME
    GEM_PATH
    RUBYOPT
  ]

  def shell(command)
    system({ 'BUNDLE_GEMFILE' => nil }, command)
    if $?.exitstatus != 0
      $stderr.puts "Command failed: #{command}"
      exit $?.exitstatus
    end
  end
end
