class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :slug
      t.hstore :skin
      t.references :supergroup, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :groups, :slug, unique: true
  end
end
