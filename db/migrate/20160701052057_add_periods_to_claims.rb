class AddPeriodsToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :pay_period, :string, default: "hour"
    add_column :claims, :time_period, :string, default: "week"
    rename_column :claims, :weekly_hours, :hours_per_period
    rename_column :claims, :hourly_pay, :pay_per_period
  end
end
