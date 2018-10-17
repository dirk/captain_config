require 'captain_config/version'

module CaptainConfig
  autoload :Service, 'captain_config/service'
  autoload :ConfiguredEntry, 'captain_config/configured_entry'
  autoload :BaseConfig, 'captain_config/models/base_config'
  autoload :BooleanConfig, 'captain_config/models/boolean_config'
end
