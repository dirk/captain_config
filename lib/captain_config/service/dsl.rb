require 'active_support/proxy_object'

class CaptainConfig::Service::DSL < ActiveSupport::ProxyObject
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def method_missing(key, *args)
    type, opts, *_rest = args

    model = case type
    when :boolean
      ::CaptainConfig::BooleanConfig
    when :integer
      ::CaptainConfig::IntegerConfig
    when :string
      ::CaptainConfig::StringConfig
    else
      raise ArgumentError.new("Unrecognized type: #{type.inspect}")
    end

    entry = ::CaptainConfig::ConfiguredEntry.new(key, model)
    if opts
      opts.each do |opt, value|
        entry.send("#{opt}=", value)
      end
    end

    service << entry
  end
end
