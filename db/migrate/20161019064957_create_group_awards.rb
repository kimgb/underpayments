class CreateGroupAwards < ActiveRecord::Migration
  class MigrationGroupAward < ActiveRecord::Base
    self.table_name = :group_awards
  end
  
  class MigrationGroup < ActiveRecord::Base
    self.table_name = :groups
  end
  
  class MigrationAward < ActiveRecord::Base
    self.table_name = :awards
    extend FriendlyId
    friendly_id :short_name, use: :slugged
  end
  
  def up
    create_table :group_awards do |t|
      t.references :group, index: true, foreign_key: true
      t.references :award, index: true, foreign_key: true
      t.string :display_text
      
      t.timestamps null: false
    end
    
    MigrationGroup.find_each do |grp|
      grp.attributes["awards"].each do |slug, display_text|
        award = MigrationAward.friendly.find(slug)
        ga = MigrationGroupAward.new(group_id: grp.id, award_id: award.id, display_text: display_text)
        
        ga.save
      end
    end
    
    remove_column :groups, :awards
  end
  
  def down
    add_column :groups, :awards, :hstore    
    drop_table :group_awards
  end
end
