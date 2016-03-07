class User < ActiveRecord::Base
  include Markdownable

  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_one :profile
  has_one :address, through: :profile
  belongs_to :claim

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

  def owners
    [self]
  end
  
  # claim pass-through methods, very simple, excuse the meta-programming
  [:ready_to_submit?, :submitted?, :employer, :workplace, :locked?].each do |m|
    define_method(m) { claim && claim.send(m) }
  end

  def not_submitted?
    !submitted?
  end

  def owns?(resource)
    # e.g. Companies and Addresses can't be owned.
    # Such resources are not edited, just disassociated.
    admin? || resource.owners.include?(self)
  end
end
