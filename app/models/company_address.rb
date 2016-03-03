class CompanyAddress < ActiveRecord::Base
  belongs_to :company
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  def owner
    false    
  end
end
