require 'active_record'

class CaptainConfig::BaseConfig < ActiveRecord::Base
  self.table_name = 'captain_configs'

  validates_presence_of :key
end
