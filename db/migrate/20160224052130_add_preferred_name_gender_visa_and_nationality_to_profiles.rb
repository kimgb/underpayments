class AddPreferredNameGenderVisaAndNationalityToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :preferred_name, :string
    add_column :profiles, :gender, :string
    add_column :profiles, :visa, :string
    add_column :profiles, :nationality, :string
  end
end
