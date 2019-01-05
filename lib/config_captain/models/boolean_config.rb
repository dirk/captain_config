require 'config_captain/models/base_config'

class ConfigCaptain::BooleanConfig < ConfigCaptain::BaseConfig
  def value
    case self.text
    when 'true'
      true
    when 'false'
      false
    else
      raise "Invalid text: #{text.inspect}"
    end
  end

  def value=(new_value)
    if new_value != true && new_value != false
      raise ArgumentError.new("Invalid value: #{new_value.inspect}")
    end

    self.text = new_value.to_s
  end

  def self.coerce(value)
    case value
    when 'true'
      true
    when 'false'
      false
    else
      raise ArgumentError.new("Cannot coerce value: #{value.inspect}")
    end
  end
end
