class AddProductSubCategories < ActiveRecord::Migration
  def change
    create_table :product_sub_categories do |t|
      t.belongs_to :product_category
      t.string :name

      t.timestamps
    end
  end
end
