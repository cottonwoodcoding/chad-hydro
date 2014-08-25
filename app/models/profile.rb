class Profile < ActiveRecord::Base
  serialize :address
  serialize :order_ids
  validates :address, presence: true
  validates :newsletter, inclusion: { in: [0, 1]}
  belongs_to :user
end
