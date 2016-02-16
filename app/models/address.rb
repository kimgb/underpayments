class Address < ActiveRecord::Base
  include Markdownable

  validates_presence_of :street_address, :town, :province, :postal_code, :country

  belongs_to :addressable, polymorphic: true

  def owner
    addressable
  end

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
