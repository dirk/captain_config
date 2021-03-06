lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "captain_config/version"

Gem::Specification.new do |spec|
  spec.name = "captain_config"
  spec.version = CaptainConfig::VERSION
  spec.authors = ["Dirk Gadsden"]
  spec.email = ["dirk@esherido.com"]

  spec.summary = 'Fast, safe configuration for Ruby on Rails applications.'
  spec.homepage = 'https://github.com/dirk/captain_config'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/dirk/captain_config'
    # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |file|
      file.match(%r{^(bin|spec)/}) ||
        file.match(%r{^\.[.\w]+$}) ||
        %[Gemfile Rakefile].include?(file)
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4.0.0'
  spec.add_dependency 'concurrent-ruby', '>= 1.0.0'

  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'httparty', '~> 0.16'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'timecop', '~> 0.9'
  spec.add_development_dependency 'wait_for_it', '~> 0.2'
end
