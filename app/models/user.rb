class User < ActiveRecord::Base
  validates_presence_of :family_name, :given_name, :email, :phone, :date_of_birth,
    :street_address, :town, :province, :postal_code, :country
end
