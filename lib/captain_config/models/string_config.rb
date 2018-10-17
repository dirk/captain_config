class CaptainConfig::StringConfig < CaptainConfig::BaseConfig
  def value
    self.text
  end

  def value=(new_value)
    self.text = new_value.to_s
  end

  def self.coerce(value)
    value.to_s
  end
end
