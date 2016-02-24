class AddContactToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :contact, :string
  end
end
