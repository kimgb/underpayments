class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.string :status
      t.string :comment
      t.string :award
      t.string :lost_wages
      t.references :employer, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.date :employment_began_on
      t.date :employment_ended_on
      t.string :employment_type
      t.boolean :regular_hours
      t.hstore :exemplary_week

      t.timestamps null: false
    end
  end
end
