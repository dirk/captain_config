require 'active_support/dependencies/autoload'

require 'captain_config/version'

module CaptainConfig
  extend ActiveSupport::Autoload

  autoload :ConfiguredEntry
  autoload :Service

  autoload_under 'middlewares' do
    autoload :PumaMiddleware
  end

  autoload_under 'models' do
    autoload :BaseConfig
    autoload :BooleanConfig
    autoload :IntegerConfig
    autoload :StringConfig
  end
end
