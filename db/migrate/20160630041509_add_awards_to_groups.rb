class AddAwardsToGroups < ActiveRecord::Migration
  class MigrationGroup < ActiveRecord::Base
    self.table_name = :groups
  end

  def up
    add_column :groups, :awards, :hstore

    MigrationGroup.first.update!(
      awards: {
        "no_award" => "Not listed / I don't know",
        "horticulture" => "Horticulture, e.g. fruit picking",
        "poultry" => "Poultry processing",
        "storage" => "Storage services, e.g. fruit packing",
        "meat" => "Meat industry"
      }
    )
  end

  def down
    remove_column :groups, :awards
  end
end
