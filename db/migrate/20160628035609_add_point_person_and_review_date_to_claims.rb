class AddPointPersonAndReviewDateToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :point_person_id, :integer
    add_column :claims, :review_date, :date
    
    add_foreign_key :claims, :users, column: :point_person_id
    add_index :claims, :point_person_id
  end
end
