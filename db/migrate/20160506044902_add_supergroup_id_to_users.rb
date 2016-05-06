class AddSupergroupIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :supergroup, index: true, foreign_key: true
  end
end
