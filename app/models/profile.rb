class Profile < ActiveRecord::Base
  attr_accessible :street_address, :city, :state, :zip, :preferred_phone, :company
  validates :street_address, :city, :state, :zip, presence: true
  belongs_to :user
end
