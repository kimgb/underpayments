class RenameSentOnToDisplayDate < ActiveRecord::Migration
  def change
    rename_column :letters, :sent_on, :display_date
  end
end
