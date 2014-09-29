class ProductSubCategory < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name, scope: :product_category_id

  belongs_to :ProductCategory
end
