class Award < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name, use: :slugged

  has_many :claims

  validates_presence_of :name, :short_name, :min_casual_rates, :min_permanent_rates
  validates_uniqueness_of :name, :short_name

  def minimum(emp_type, year)
    year = [year, 2010].max.to_s

    if emp_type == "permanent"
      BigDecimal(min_permanent_rates.dig(year))
    else
      BigDecimal(min_casual_rates.dig(year))
    end
  end
end
