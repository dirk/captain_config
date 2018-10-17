require 'active_support/dependencies/autoload'

require 'captain_config/version'

module CaptainConfig
  extend ActiveSupport::Autoload

  autoload :Service
  autoload :ConfiguredEntry

  autoload_under 'models' do
    autoload :BaseConfig
    autoload :BooleanConfig
    autoload :IntegerConfig
    autoload :StringConfig
  end
end
