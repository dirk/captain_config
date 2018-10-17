require 'active_record'

class CaptainConfig::BaseConfig < ActiveRecord::Base
  self.abstract_class = true
end
