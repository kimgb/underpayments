class Award < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name, use: :slugged

  has_many :claims
  has_many :group_awards, inverse_of: :award
  has_many :groups, through: :group_awards

  validates_presence_of :name, :short_name, :min_casual_rates, :min_permanent_rates
  validates_uniqueness_of :name, :short_name

  def minimum(emp_type, year)
    year = [year, 2010].max
    year = [2016, year].min.to_s # somebody tried entering Aug 2017 job start

    if emp_type == "permanent"
      BigDecimal(min_permanent_rates.dig(year))
    else
      BigDecimal(min_casual_rates.dig(year))
    end
  end
end
