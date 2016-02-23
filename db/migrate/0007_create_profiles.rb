class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string      :family_name
      t.string      :given_name
      t.string      :preferred_name
      t.date        :date_of_birth
      t.string      :phone
      t.string      :gender
      t.string      :visa
      t.string      :nationality
      t.string      :preferred_language
      t.references  :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
