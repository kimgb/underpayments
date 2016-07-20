class ClaimCompany < ActiveRecord::Base
  belongs_to :claim, inverse_of: :claim_companies
  belongs_to :company, inverse_of: :claim_companies
  
  accepts_nested_attributes_for :company
  
  scope :active, -> { where(is_active: true) }
  scope :workplace, -> { where(is_workplace: true) }
  scope :employer, -> { where(is_employer: true) }
  
  # validates :company_id, uniqueness: { scope: :claim_id }, if: :is_active?
  validate :workplace_or_employer, :unique_claim_id_when_employer_and_active, 
    :unique_claim_id_when_workplace_and_active, :unique_claim_and_company_when_active
  
  def owners
    company ? company.owners : []
  end
  
  def is_employer!
    self.update(is_employer: true)
  end
  
  def is_workplace!
    self.update(is_workplace: true)
  end
  
  def deactivate!
    self.update(is_active: false)
  end
  
  def activate!
    self.update(is_active: true)
  end
  
  private
  def workplace_or_employer
    unless (is_workplace? || is_employer?)
      errors.add(:claim_id, "must be a workplace, employer, or both")
    end
  end
  
  def unique_claim_id_when_employer_and_active
    if is_active? && is_employer? && ClaimCompany.exists?(["claim_id = ? AND is_active = true AND is_employer = true AND id != ?", claim_id, id.to_i])
      errors.add(:claim_id, "already has an active employer")
    end
  end
  
  def unique_claim_id_when_workplace_and_active
    if is_active? && is_workplace? && ClaimCompany.exists?(["claim_id = ? AND is_active = true AND is_workplace = true AND id != ?", claim_id, id.to_i])
      errors.add(:claim_id, "already has an active workplace")
    end
  end
  
  def unique_claim_and_company_when_active
    if is_active? && ClaimCompany.exists?(["is_active = true AND claim_id = ? AND company_id = ? AND id != ?", claim_id, company_id, id.to_i])
      errors.add(:claim_id, "has already been added to this claim as a workplace or employer")
    end
  end
end
