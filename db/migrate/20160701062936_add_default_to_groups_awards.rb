class AddDefaultToGroupsAwards < ActiveRecord::Migration
  def up
    change_column :groups, :awards, :hstore, default: ''
  end

  def down
  end
end
