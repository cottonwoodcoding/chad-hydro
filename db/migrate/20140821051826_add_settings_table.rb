class AddSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :name
      t.string :value

      t.timestamps
    end
  end
end
