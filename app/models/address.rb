class Address < ActiveRecord::Base
  validates_presence_of :street_address, :town, :province, :postal_code, :country

  belongs_to :addressable, polymorphic: true

  def to_s
    "#{street_address}\n" +
    "#{town} #{province}   #{postal_code}\n" +
    "#{country}"
  end
end
