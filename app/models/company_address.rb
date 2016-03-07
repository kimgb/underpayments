class CompanyAddress < ActiveRecord::Base
  belongs_to :company
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  def owners
    company ? company.owners : []
  end
end
