class Company < ActiveRecord::Base
  include Markdownable
  
  has_many :claim_companies, -> { where(is_active: true) }, inverse_of: :company
  has_many :claims, through: :claim_companies
  
  accepts_nested_attributes_for :claim_companies
  
  has_one :company_address, -> { where(is_active: true) }
  has_one :address, through: :company_address

  validates_presence_of :name, :contact
  validate :presence_of_phone_or_email
  validate :abn_well_formed
  
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
  
  def abn_well_formed
    if abn.present? && !abn_valid?(abn)
      errors.add(:abn, "must be valid.")
    end
  end
  
  def abn_valid?(abn)
    # Strip non-digits, & get an array of digits.
    abn_digits = abn.to_s.gsub(/\D/, '').chars.map(&:to_i)
    
    # Fail it if it's not 11 digits long.
    return false unless abn_digits.size == 11
    
    # Run it through the weighting, get the remainder from 89, make sure it's 0.
    abn.map.with_index(&method(:abn_weighting)).sum % 89 == 0
  end
  
  def abn_weighting(n, idx)
    idx.zero? ? (n - 1) * 10 : n * ((idx + 1) * 2 - 3)
  end
end
