class Employer < ActiveRecord::Base
  belongs_to :claim
  has_one :address, as: :addressable

  validates_presence_of :name
end
