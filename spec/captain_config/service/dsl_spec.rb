require 'spec_helper'

RSpec.describe CaptainConfig::Service::DSL do
  def factory(&block)
    CaptainConfig::Service.new(load_after_initialize: false, &block)
  end

  context 'with a boolean' do
    it 'initializes without a default' do
      service = factory do
        some_boolean :boolean
      end

      entry = service.configured_entries.fetch :some_boolean
      expect(entry.key).to eq :some_boolean
      expect(entry.model).to eq CaptainConfig::BooleanConfig
      expect(entry.default).to eq nil
    end

    it 'initializes with a default' do
      service = factory do
        some_boolean :boolean, default: true
      end

      entry = service.configured_entries.fetch :some_boolean
      expect(entry.key).to eq :some_boolean
      expect(entry.model).to eq CaptainConfig::BooleanConfig
      expect(entry.default).to eq true
    end
  end
end
