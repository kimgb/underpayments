class User < ActiveRecord::Base
  validates_presence_of :family_name, :given_name, :email, :phone#, :date_of_birth

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
