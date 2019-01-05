require 'active_record'

class ConfigCaptain::BaseConfig < ActiveRecord::Base
  # Snake-cased version of "captain's configs".
  self.table_name = 'captains_configs'

  validates_presence_of :key
end
