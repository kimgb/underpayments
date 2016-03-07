class Company < ActiveRecord::Base
  include Markdownable
  
  has_many :claim_companies, -> { where(is_active: true) }, inverse_of: :company
  has_many :claims, through: :claim_companies
  
  accepts_nested_attributes_for :claim_companies
  
  has_one :company_address, -> { where(is_active: true) }
  has_one :address, through: :company_address

  validates_presence_of :name, :contact
  validate :presence_of_phone_or_email
  
  def done?
    valid? && address.present? && address.valid? && (phone || email)
  end
  
  def owners
    claims ? claims.collect(&:user) : []
  end
  
  def presentable_against?(claim)
    claim_companies.where(claim: claim).any? { |cc| cc.is_employer || cc.is_workplace }
  end
  
  private
  def presence_of_phone_or_email
    unless phone.present? || email.present?
      errors.add(:company, "must contain a phone or email contact")
    end
  end
end
