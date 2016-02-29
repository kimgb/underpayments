class CreateClaimCompanies < ActiveRecord::Migration
  def change
    create_table :claim_companies do |t|
      t.references :claim, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true
      t.boolean :is_active
      t.boolean :is_employer
      t.boolean :is_workplace

      t.timestamps null: false
    end
  end
end
