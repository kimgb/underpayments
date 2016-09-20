class CompanyAddress < ActiveRecord::Base
  belongs_to :company
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  scope :active, -> { where(is_active: true) }
  
  def owners
    company ? company.owners : []
  end
end
