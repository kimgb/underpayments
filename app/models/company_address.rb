class CompanyAddress < ActiveRecord::Base
  belongs_to :company
  belongs_to :address
end
