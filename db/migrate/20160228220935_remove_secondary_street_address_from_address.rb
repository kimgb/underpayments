class RemoveSecondaryStreetAddressFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :secondary_street_address
  end
end
