class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.string :status
      t.string :comment
      t.string :award
      t.decimal :weekly_hours, precision: 10, scale: 2
      t.decimal :hourly_pay, precision: 10, scale: 2
      t.date :employment_began_on
      t.date :employment_ended_on
      t.string :employment_type
      t.boolean :regular_hours
      t.jsonb :exemplary_week
      t.boolean :submitted_for_review, default: false
      t.timestamp :submitted_on
      t.jsonb :total_hours_by_year
      t.references :employer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
