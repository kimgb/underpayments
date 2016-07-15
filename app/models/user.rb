class User < ActiveRecord::Base
  include Markdownable
  
  attr_accessor :locale_for_email

  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :invitable

  belongs_to :claim
  belongs_to :group
  has_one :profile, dependent: :destroy
  has_one :address, through: :profile
  has_many :notes, foreign_key: "author_id"
  has_many :point_person_on, class_name: "Claim", foreign_key: "point_person_id"
  
  scope :admin, -> { where(admin: true) }

  delegate :full_name, :proper_full_name, :preferred_language, :phone,
    to: :profile, prefix: false, allow_nil: true  
  delegate :ready_to_submit?, :submitted?, :not_submitted?, :employer, :workplace, :locked?, 
    to: :claim, prefix: false, allow_nil: true
  delegate :persisted?, to: :claim, prefix: true, allow_nil: true
  delegate :supergroup, to: :group, prefix: false, allow_nil: true

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

  def owns?(resource)
    # e.g. Companies and Addresses can't be owned.
    # Such resources are not edited, just disassociated.
    admin? || resource.owners.include?(self)
  end
  
  def join_form_params
    path_to_self = Rails.application.routes.url_helpers.user_path(self, skin: self.group)
    
    { "callback_url" => URI::encode("#{ENV['host'] + path_to_self}", /\W/), 
      "email" => email }.merge(profile && profile.join_form_params || {})
  end
end
