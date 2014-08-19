class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :customer_id
      t.text :address
      t.text :order_ids

      t.timestamps
    end
  end
end
