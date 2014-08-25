class AddNewsletterFlagToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :newsletter, :integer, default: 0
  end
end
