class Company < ActiveRecord::Base
  include Markdownable
  include PgSearch
  
  has_one :company_address, -> { active }
  has_one :address, through: :company_address
  has_many :claim_companies, -> { active }, inverse_of: :company
  has_many :claims, through: :claim_companies
  # has_many :child_companies, class_name: "Company", foreign_key: "parent_company_id"
  # belongs_to :parent_company, class_name: "Company"
  
  accepts_nested_attributes_for :claim_companies
  
  pg_search_scope :search, against: %i(name), 
    using: { 
      tsearch: { 
        prefix: true,
        dictionary: "english"
      } 
    }
  
  validates_presence_of :name, :contact
  validate :presence_of_phone_or_email
  validate :abn_well_formed
  
  def done?
    valid? && address.present? && address.valid? && (phone || email)
  end
  
  def owners
    claims.collect(&:user)
  end
  
  def presentable_against?(claim)
    # Note: claim_companies fail validation unless they're a workplace/employer.
    claim_companies.where(claim: claim).any?
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
    abn_digits.map.with_index(&method(:abn_weighting)).sum % 89 == 0
  end
  
  def abn_weighting(n, idx)
    idx.zero? ? (n - 1) * 10 : n * ((idx + 1) * 2 - 3)
  end
end
