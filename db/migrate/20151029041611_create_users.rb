class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :family_name
      t.string :given_name
      t.string :email
      t.string :phone
      t.string :country
      t.string :postal_code
      t.string :province
      t.string :town
      t.string :street_address
      t.string :secondary_street_address
      t.string :preferred_language
      t.string :follow_up_detail

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
