class User < ActiveRecord::Base
  include Markdownable

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_one :profile
  has_one :address, as: :addressable
  belongs_to :claim
  has_one :employer, through: :claim
  has_one :workplace, through: :claim

  validates_presence_of :email, :encrypted_password

  def self.presentable_attributes
    ["email"]
  end
  
  def full_name
    profile && profile.full_name
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
  
  def submitted?
    claim && claim.submitted?
  end
  
  alias_method :locked?, :submitted?
  
  def not_submitted?
    !submitted?
  end
end
