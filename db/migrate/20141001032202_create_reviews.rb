class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :product_id
      t.text :review_text
      t.float :rating
      t.string :user

      t.timestamps
    end
  end
end
