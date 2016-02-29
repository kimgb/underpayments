class RemoveAddressableTypeFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :addressable_type
  end
end
