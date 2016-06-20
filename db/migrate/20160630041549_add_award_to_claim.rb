class AddAwardToClaim < ActiveRecord::Migration
  def change
    rename_column :claims, :award, :award_legacy
    add_reference :claims, :award, index: true, foreign_key: true
  end
  
  Rake::Task['claims:migrate_award_column'].invoke
end
