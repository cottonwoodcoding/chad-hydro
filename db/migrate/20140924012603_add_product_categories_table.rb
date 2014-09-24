class AddProductCategoriesTable < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.text :category

      t.timestamps
    end
  end
end
