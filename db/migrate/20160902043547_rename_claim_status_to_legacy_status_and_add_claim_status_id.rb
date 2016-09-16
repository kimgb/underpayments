class RenameClaimStatusToLegacyStatusAndAddClaimStatusId < ActiveRecord::Migration
  def change
    change_table :claims do |t|
      t.rename :status, :legacy_status
      t.references :claim_stage, index: true, foreign_key: true
    end
  end
end
