class AddCategoryToClaimStages < ActiveRecord::Migration
  def change
    # add_column :claim_stages, :category, :string
    add_column :claim_stages, :category, :integer, default: 0
  end
end
