class RemoveEmployerAndWorkplaceFromClaims < ActiveRecord::Migration
  def change
    remove_reference :claims, :employer
    remove_reference :claims, :workplace
  end
end
