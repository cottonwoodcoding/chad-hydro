class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :user
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :preferred_phone
      t.string :company
      t.integer :newsletter, default: 0

      t.timestamps
    end
  end
end
