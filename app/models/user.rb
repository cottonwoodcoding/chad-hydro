class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessible :first_name, :last_name, :email, :password, :shopify_customer_id
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable
  validates :first_name, :last_name, :email, presence: true
  has_one :profile
end
