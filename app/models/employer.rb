class Employer < ActiveRecord::Base
  has_many :claims
  has_many :users, through: :claims
  has_one :address, as: :addressable

  validates_presence_of :name

  def owner
    self.claim.owner
  end
end
