class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :secondary_street_address
      t.string :town
      t.string :province
      t.string :postal_code
      t.string :country
      t.references :addressable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
