class AddIntroToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :intro, :text
  end
end
