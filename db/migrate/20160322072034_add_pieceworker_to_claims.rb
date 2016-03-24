class AddPieceworkerToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :pieceworker, :boolean, default: false
  end
end
