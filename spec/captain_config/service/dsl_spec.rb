require 'spec_helper'

RSpec.describe ConfigCaptain::Service::DSL do
  def factory(&block)
    ConfigCaptain::Service.new(load_after_initialize: false, &block)
  end

  describe 'with a boolean' do
    it 'initializes without a default' do
      service = factory do
        some_boolean :boolean
      end

      entry = service.configured_entries.fetch :some_boolean
      expect(entry.key).to eq :some_boolean
      expect(entry.model).to eq ConfigCaptain::BooleanConfig
      expect(entry.default).to eq nil
    end

    it 'initializes with a default' do
      service = factory do
        some_boolean :boolean, default: true
      end

      entry = service.configured_entries.fetch :some_boolean
      expect(entry.key).to eq :some_boolean
      expect(entry.model).to eq ConfigCaptain::BooleanConfig
      expect(entry.default).to eq true
    end
  end

  describe 'with an integer' do
    it 'initializes without a default' do
      service = factory do
        some_integer :integer
      end

      entry = service.configured_entries.fetch :some_integer
      expect(entry.key).to eq :some_integer
      expect(entry.model).to eq ConfigCaptain::IntegerConfig
      expect(entry.default).to eq nil
    end

    it 'initializes with a default' do
      service = factory do
        some_integer :integer, default: 123
      end

      entry = service.configured_entries.fetch :some_integer
      expect(entry.key).to eq :some_integer
      expect(entry.model).to eq ConfigCaptain::IntegerConfig
      expect(entry.default).to eq 123
    end
  end

  describe 'with a string' do
    it 'initializes without a default' do
      service = factory do
        some_string :string
      end

      entry = service.configured_entries.fetch :some_string
      expect(entry.key).to eq :some_string
      expect(entry.model).to eq ConfigCaptain::StringConfig
      expect(entry.default).to eq nil
    end

    it 'initializes with a default' do
      service = factory do
        some_string :string, default: 'foobar'
      end

      entry = service.configured_entries.fetch :some_string
      expect(entry.key).to eq :some_string
      expect(entry.model).to eq ConfigCaptain::StringConfig
      expect(entry.default).to eq 'foobar'
    end
  end
end
