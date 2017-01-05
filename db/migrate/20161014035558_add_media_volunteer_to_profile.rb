class AddMediaVolunteerToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :media_volunteer, :boolean, default: false
  end
end
