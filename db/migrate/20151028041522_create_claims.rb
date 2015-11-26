class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.string :status
      t.string :comment
      t.string :award
      t.string :lost_wages
      t.integer :total_hours
      t.decimal :hourly_pay, precision: 10, scale: 2
      t.date :employment_began_on
      t.date :employment_ended_on
      t.string :employment_type
      t.boolean :regular_hours
      t.hstore :exemplary_week

      t.timestamps null: false
    end
  end
end
