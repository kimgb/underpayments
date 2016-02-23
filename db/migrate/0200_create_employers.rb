class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :contact
      t.string :abn
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
  end
end
