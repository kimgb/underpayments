class CreateCompanyAddresses < ActiveRecord::Migration
  def change
    create_table :company_addresses do |t|
      t.references :company, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
