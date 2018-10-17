class CaptainConfig::Service
  autoload :DSL, "captain_config/service/dsl"

  # The statically-defined entries that this service should support.
  attr_reader :configured_entries

  # The keys and values read from the database (or defaults).
  attr_reader :configs

  def initialize(&block)
    @configured_entries = {}
    @configs = nil

    DSL.new(self).instance_eval(&block)
  end

  def <<(configured_entry)
    @configured_entries[configured_entry.key] = configured_entry
  end

  def loaded?
    !configs.nil?
  end

  # Load new values from the database (or default values from the
  # configured entries).
  def load
    new_configs = {}

    records = CaptainConfig::BaseConfig
      .where(keys: configured_entries.keys)
      .map { |record| [record.key.to_sym, record] }
      .to_hash

    configured_entries.each do |key, configured_entry|
      record = records[key]

      value = if record
        # Check that it's the type we're expecting.
        expected = record.klass
        actual = configured_entry.model
        if expected != actual
          raise(
            "Error loading #{key}: record class from database doesn't match " \
            "configured class (expected: #{expected}, got: #{actual})",
          )
        end
        record.value
      else
        configured_entry.default_value
      end

      new_configs[key] = value
    end

    @configs = new_configs
  end
end
