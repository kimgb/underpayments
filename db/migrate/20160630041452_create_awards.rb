class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.string :short_name
      t.string :slug
      t.decimal :default_minimum
      t.hstore :min_casual_rates
      t.hstore :min_permanent_rates
      
      t.timestamps null: false
    end
    
    add_index :awards, :slug, unique: true
  end
end
