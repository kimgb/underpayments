class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  validates_presence_of :family_name, :given_name, :phone, :date_of_birth

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  has_one :claim
  accepts_nested_attributes_for :claim

  def full_name
    # FIXME should be locale dependent in production
    "#{given_name} #{family_name}"
  end

  # def has_address?
  #   self.address.present?
  # end

  # def has_claim?
  #   self.claim.present?
  # end
end
