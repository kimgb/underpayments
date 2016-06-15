class AddAwardToClaim < ActiveRecord::Migration
  def change
    add_reference :claims, :award, index: true, foreign_key: true
  end
end
