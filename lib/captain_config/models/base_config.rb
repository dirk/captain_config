require 'active_record'

class CaptainConfig::BaseConfig < ActiveRecord::Base
  self.abstract_class = true
  self.table_name = 'captain_configs'
end
