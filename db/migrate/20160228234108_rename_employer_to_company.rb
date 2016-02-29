class RenameEmployerToCompany < ActiveRecord::Migration
  def change
    rename_table :employers, :companies
  end
end
