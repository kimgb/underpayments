class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :abn
      t.string :phone
      t.string :email
      t.references :claim, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
