module ConfigCaptain::Shell
  def shell(command)
    system({ 'BUNDLE_GEMFILE' => nil }, command)
    if $?.exitstatus != 0
      $stderr.puts "Command failed: #{command}"
      exit $?.exitstatus
    end
  end
end
