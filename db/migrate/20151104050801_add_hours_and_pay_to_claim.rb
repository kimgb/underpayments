class AddHoursAndPayToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :total_hours, :integer
    add_column :claims, :hourly_pay, :integer
  end
end
