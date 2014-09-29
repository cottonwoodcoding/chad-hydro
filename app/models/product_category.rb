class ProductCategory < ActiveRecord::Base
  attr_accessible :category
  has_many :product_sub_categories
end
