require 'active_support/proxy_object'

class ConfigCaptain::Service::DSL < ActiveSupport::ProxyObject
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def method_missing(key, *args)
    type, opts, *_rest = args

    model = case type
    when :boolean
      ::ConfigCaptain::BooleanConfig
    when :integer
      ::ConfigCaptain::IntegerConfig
    when :string
      ::ConfigCaptain::StringConfig
    else
      raise ArgumentError.new("Unrecognized type: #{type.inspect}")
    end

    entry = ::ConfigCaptain::ConfiguredEntry.new(key, model)
    if opts
      opts.each do |opt, value|
        entry.send("#{opt}=", value)
      end
    end

    service << entry
  end
end
