class AddPayslipsReceivedToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :payslips_received, :boolean, default: false
  end
end
