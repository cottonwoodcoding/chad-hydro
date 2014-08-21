class Setting < ActiveRecord::Base
  attr_accessible :name, :value
  validates :name, :value, presence: true
  validates :name, uniqueness: true

  def self.setting_value(setting_name)
    self.find_by_name(setting_name).value
  end
end
