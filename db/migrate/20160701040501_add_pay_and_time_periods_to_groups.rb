class AddPayAndTimePeriodsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :pay_periods, :text, array: true, default: []
    add_column :groups, :time_periods, :text, array: true, default: []
  end
end
