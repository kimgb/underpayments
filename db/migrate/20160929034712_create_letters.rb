class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.references :claim, index: true, foreign_key: true
      t.date :sent_on
      t.string :addressee
      t.references :address, index: true, foreign_key: true
      t.text :body
      t.string :contact_inbox
      t.text :signature
      
      t.timestamps
    end
  end
end
