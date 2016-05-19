class CreateSupergroups < ActiveRecord::Migration
  def change
    create_table :supergroups do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.string :www
    end
  end
end
