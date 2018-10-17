class CaptainConfig::Service
  autoload :DSL, "captain_config/service/dsl"

  attr_reader :configured_entries

  def initialize(&block)
    @configured_entries = {}

    DSL.new(self).instance_eval(&block)
  end

  def <<(configured_entry)
    @configured_entries[configured_entry.key] = configured_entry
  end
end
