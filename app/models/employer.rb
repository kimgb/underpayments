class Employer < ActiveRecord::Base
  has_many :claims

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address

  validates_presence_of :name
end
