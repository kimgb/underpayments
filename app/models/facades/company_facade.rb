class CompanyFacade
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_reader :claim_company
  
  delegate :id, :claim, :company, :is_active, :is_employer, :is_workplace,
    :is_active=, :is_employer=, :is_workplace=, :save!, :persisted?,
    to: :claim_company, prefix: false, allow_nil: false
  delegate :name, :abn, :phone, :email, :contact,
    :name=, :abn=, :phone=, :email=, :contact=,
    to: :company, prefix: false, allow_nil: false
  delegate :id, :id=, :user, to: :claim, prefix: true, allow_nil: false
  delegate :id, :id=, to: :company, prefix: true, allow_nil: false
  
  # new/create pattern:
  def initialize(company, claim, claim_company = ClaimCompany.new)
    @claim_company = claim_company
    
    unless persisted?
      @claim_company.attributes = { company: company, claim: claim, is_active: true }
    end
  end
  
  # show/edit/update:
  def self.find(id)
    cc = ClaimCompany.find(id)
    
    self.new(cc.company, cc.claim, cc)
  end
  
  def attributes=(attributes)
    attributes.each { |k, v| self.send("#{k}=", v) }
  end
  
  def update(attributes)
    self.attributes=(attributes)
    
    self.save!
  end
end
