module CompaniesHelper
  def home_title(company, claim)
    # automatically scoped to active ClaimCompanies
    claim_companies = company.claim_companies.where(claim: claim)
    
    result = [
      if claim_companies.any?(&:is_workplace) then "Workplace" else nil end, 
      if claim_companies.any?(&:is_employer) then "Employer" else nil end
    ].compact.join(" & ")
    
    result.blank? ? result : "(#{result})"
  end
end
