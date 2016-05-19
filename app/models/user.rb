class User < ActiveRecord::Base
  include Markdownable
  
  attr_accessor :locale_for_email

  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :invitable

  has_one :profile, dependent: :destroy
  has_one :address, through: :profile
  belongs_to :claim
  belongs_to :group
  
  delegate :persisted?, to: :claim, prefix: true, allow_nil: true
  delegate :full_name, to: :profile, prefix: true, allow_nil: true
  delegate :phone, to: :profile, prefix: true, allow_nil: true

  validates_presence_of :email, :encrypted_password

  def self.presentable_attributes
    ["email"]
  end

  def admin?
    admin
  end

  def owners
    [self]
  end
  
  # override devise default to deliver in background.
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
  
  # claim pass-through methods, very simple, excuse the meta-programming
  [:ready_to_submit?, :submitted?, :employer, :workplace, :locked?].each do |m|
    define_method(m) { claim && claim.send(m) }
  end
  
  # ditto for profile pass-through methods
  [:full_name, :preferred_language].each do |m|
    define_method(m) { profile && profile.send(m) }
  end

  def not_submitted?
    !submitted?
  end

  def owns?(resource)
    # e.g. Companies and Addresses can't be owned.
    # Such resources are not edited, just disassociated.
    admin? || resource.owners.include?(self)
  end
  
  def join_form_params
    { "email" => email }.merge(profile && profile.join_form_params || {})
  end
end
