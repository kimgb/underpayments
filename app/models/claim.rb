class Claim < ActiveRecord::Base
  belongs_to :user

  belongs_to :employer
  accepts_nested_attributes_for :employer

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  validates_presence_of :award, :address, :employer,
    :employment_began_on, :employment_ended_on, :employment_type
end
