require 'captain_config/models/base_config'

class CaptainConfig::IntegerConfig < CaptainConfig::BaseConfig
  def value
    Integer(self.text)
  end

  def value=(new_value)
    unless new_value.is_a?(Integer)
      raise ArgumentError.new("Invalid value: #{new_value.inspect}")
    end

    self.text = new_value.to_s
  end

  def self.coerce(value)
    Integer(value)
  end
end
