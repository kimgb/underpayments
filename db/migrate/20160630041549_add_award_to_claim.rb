class AddAwardToClaim < ActiveRecord::Migration
  class MigrationClaim < ActiveRecord::Base
    self.table_name = :claims
    belongs_to :award
    
    def migrate_award_column!
      award = Award.friendly.find(self.award_legacy)
      
      self.update!(award_id: award.id)
    end
  end
  
  def up
    rename_column :claims, :award, :award_legacy
    add_reference :claims, :award, index: true, foreign_key: true
    MigrationClaim.find_each(&:migrate_award_column!)
    remove_column :claims, :award_legacy
  end
  
  def down
    remove_reference :claims, :award
    add_column :claims, :award, :string
  end
end
