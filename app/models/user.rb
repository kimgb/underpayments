class User < ActiveRecord::Base
<<<<<<< HEAD
  validates_presence_of :family_name, :given_name, :email, :phone, :date_of_birth,
    :street_address, :town, :province, :postal_code, :country
end
=======
  validates_presence_of :family_name, :given_name, :email, :phone, :date_of_birth

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  has_one :claim
  accepts_nested_attributes_for :claim

  def full_name
    # FIXME should be locale dependent in production
    "#{given_name} #{family_name}"
  end
end

# User form:
#   1. Fucking horrendous.
#
#   User fields
#   => User address fields
#   => User claim fields
#      => Claim address fields
#      => Claim employer fields
#         => Employer address fields
>>>>>>> 165f7838e4b001f6b224e95ba3d40b382436c82f
