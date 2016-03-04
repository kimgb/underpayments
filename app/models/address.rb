class Address < ActiveRecord::Base
  include Markdownable

  validates_presence_of :street_address, :town, :province, :postal_code, :country

  has_many :profiles
  has_many :company_addresses

  def owner
    false
  end
  
  def to_s
    "#{street_address}, #{town}, #{province} #{postal_code}"
  end
  
  alias_method :done?, :valid?

  # def markdown_postal_format(addressee)
  #   <<-MD.gsub(/^\s+\|/, "")
  #     |#{addressee}  
  #     |#{street_address}  
  #     |#{if secondary_street_address then secondary_street_address + "  " else "" end}
  #     |#{town}  
  #     |#{province}&emsp;#{postal_code}
  #   MD
  # end
end
