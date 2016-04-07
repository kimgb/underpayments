class Address < ActiveRecord::Base
  include Markdownable

  validates_presence_of :street_address, :town, :province, :postal_code, :country

  has_many :profiles
  has_many :company_addresses
  
  def self.attr_transform
    {
      "street_address" => { method: String.instance_method(:gsub), args: [/(\r?\n)/, '  \1'] }
    }
  end

  def owners
    profile_owners = profiles ? profiles.collect(&:owners).flatten : []
    company_owners = company_addresses ? company_addresses.collect(&:owners).flatten : []
    
    profile_owners | company_owners
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
