class Employer < ActiveRecord::Base
  include Markdownable
  
  has_many :claims
  has_many :users, through: :claims
  has_one :address, as: :addressable

  validates_presence_of :name, :contact

  def owner
    false
  end
  
  def owners
    users
  end
end
