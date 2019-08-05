module CaptainConfig::Shell
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
