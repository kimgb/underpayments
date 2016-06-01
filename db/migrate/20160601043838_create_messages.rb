class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :parent_message_id, index: true, foreign_key: true
      t.references :claim, index: true, foreign_key: true
      t.string :recipient
      t.string :sender
      t.string :subject
      t.string :from
      t.timestamp :sent_at
      t.string :token
      t.text :full_plain
      t.text :full_html
      t.text :stripped_plain
      t.text :stripped_html
      
      t.timestamps null: false
    end
  end
end
