class AddAddressToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :address, index: true, foreign_key: true
  end
end
