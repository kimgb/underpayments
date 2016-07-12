class AddReadyToSubmitToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :ready_to_submit, :boolean
  end
end
