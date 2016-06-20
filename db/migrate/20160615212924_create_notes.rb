class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :summary
      t.text :explanation
      t.references :author, references: :users
      t.string :annotatable_type
      t.integer :annotatable_id

      t.timestamps null: false
    end
    
    add_foreign_key :notes, :users, column: :author_id
    add_index :notes, :author_id
    add_index :notes, [:annotatable_id, :annotatable_type]
  end
end
