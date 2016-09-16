class CreateCompanyContacts < ActiveRecord::Migration
  class MigrationCompany < ActiveRecord::Base
    self.table_name = :companies
  end
  
  class MigrationCompanyContact < ActiveRecord::Base
    self.table_name = :company_contacts
  end
  
  def up
    create_table :company_contacts do |t|
      t.string :name, null: false
      t.string :title
      t.string :phone
      t.string :email
      t.references :company, index: true, foreign_key: true
      
      t.timestamps null: false
    end
    
    MigrationCompany.find_each do |co|
      mcc = MigrationCompanyContact.new(
        name: co.contact,
        phone: co.phone,
        email: co.email,
        company_id: co.id
      )
      
      mcc.save      
    end
    
    remove_column :companies, :contact
  end
  
  def down
    add_column :companies, :contact, :string
    
    MigrationCompanyContact.find_each do |cc|
      begin
        co = MigrationCompany.find(cc.company_id)
        
        co.phone ||= cc.phone
        co.email ||= cc.email
        co.contact ||= cc.name
        
        co.save
      rescue ActiveRecord::RecordNotFound
        next
      end
    end
    
    drop_table :company_contacts
  end
end
