class AddSentToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :sent, :boolean
  end
end
