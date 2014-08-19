class Profile < ActiveRecord::Base
  serialize :address
  serialize :order_ids
  validates :address, presence: true
end
