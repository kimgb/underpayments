class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  has_one :address, as: :addressable
  belongs_to :claim

  def full_name
    # FIXME should be locale dependent in production
    "#{given_name} #{family_name}"
  end

  def admin?
    admin
  end

  def owner
    self
  end

  def owns?(resource)
    # what about employers - multiple users through claims
    self.admin? || self == resource.owner
  end
end
