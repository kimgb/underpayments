class Profile < ActiveRecord::Base
  include Markdownable
  
  belongs_to :user
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  validates_presence_of :family_name, :given_name, :phone, :date_of_birth, 
    :nationality
    
  alias_method :done?, :valid?

  def self.presentable_attributes
    super.reject do |attr| 
      ["gender", "visa", "nationality"].include? attr 
    end
  end

  def full_name
    [given_name, family_name].join(" ")
  end

  def owner
    user
  end
end
