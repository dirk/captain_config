class CaptainConfig::ConfiguredEntry
  attr_reader :key
  # Class of the model (eg. `CaptainConfig::BooleanConfig`).
  attr_reader :model
  attr_accessor :default

  def initialize(key, model)
    @key = key
    @model = model
    @default = nil
  end

  def default_value
    if default.respond_to?(:call)
      default.call
    else
      default
    end
  end
end
