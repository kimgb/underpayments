class DropWorkplaces < ActiveRecord::Migration
  def up
    drop_table :workplaces
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
