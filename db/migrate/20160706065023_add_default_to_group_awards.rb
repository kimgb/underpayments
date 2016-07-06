class AddDefaultToGroupAwards < ActiveRecord::Migration
  def up
    change_column :groups, :awards, :hstore, default: '', null: false
  end
  
  def down
    change_column :groups, :awards, :hstore, default: nil, null: true
  end
end
