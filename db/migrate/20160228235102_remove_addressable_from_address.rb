class RemoveAddressableFromAddress < ActiveRecord::Migration
  def change
    remove_reference :addresses, :addressable
  end
end
