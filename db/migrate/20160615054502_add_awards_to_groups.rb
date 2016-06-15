class AddAwardsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :awards, :hstore
  end
end
