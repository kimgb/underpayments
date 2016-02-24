class AddWorkplaceAndSubmissionsToClaims < ActiveRecord::Migration
  def change
    add_reference :claims, :workplace, foreign_key: true, index: true
    add_column :claims, :submitted_for_review, :boolean
    add_column :claims, :submitted_on, :timestamp
  end
end
