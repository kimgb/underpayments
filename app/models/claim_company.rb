class ClaimCompany < ActiveRecord::Base
  belongs_to :claim, inverse_of: :claim_companies
  belongs_to :company, inverse_of: :claim_companies
  
  accepts_nested_attributes_for :company
  
  scope :active, -> { where(is_active: true) }
  scope :workplace, -> { where(is_workplace: true) }
  scope :employer, -> { where(is_employer: true) }
  
  validate :unique_claim_id_when_employer_and_active
  validate :unique_claim_id_when_workplace_and_active
  
  def owners
    company ? company.owners : []
  end
  
  private
  def unique_claim_id_when_employer_and_active
    if is_active && is_employer && ClaimCompany.exists?(["claim_id = ? AND is_active = true AND is_employer = true AND id != ?", claim_id, id.to_i])
      errors.add(:claim_id, "already has an active employer")
    end
  end
  
  def unique_claim_id_when_workplace_and_active
    if is_active && is_workplace && ClaimCompany.exists?(["claim_id = ? AND is_active = true AND is_workplace = true AND id != ?", claim_id, id.to_i])
      errors.add(:claim_id, "already has an active workplace")
    end
  end
end
