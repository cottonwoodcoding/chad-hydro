class AddSettingsTable < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.text :name
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :settings
  end
end
