class User < ActiveRecord::Base
  include Markdownable

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_one :profile
  has_one :address, as: :addressable
  belongs_to :claim
  has_one :employer, through: :claim

  validates_presence_of :email, :encrypted_password

  def presentable_attributes
    attributes.slice("email")
  end

  def admin?
    admin
  end

  def owner
    self
  end

  def owns?(resource)
    # Employer#owner returns false - puzzle piece to be considered.
    admin? || self == resource.owner
  end

  def ready_to_submit?
    claim && claim.ready_to_submit?
  end
end
