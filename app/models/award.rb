class Award < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name, use: :slugged
  
  has_many :claims
  
  validates_presence_of :name, :short_name, :min_casual_rates, :min_permanent_rates
  validates_uniqueness_of :name, :short_name
  
  def minimum(emp_type, year)
    year = year.to_s
    
    if emp_type == "permanent"
      BigDecimal(min_permanent_rates.dig(year))
    else
      BigDecimal(min_casual_rates.dig(year))
    end
  end
  
  #{
  #   2016 => {
  #     "no_award" => { "permanent" => 17.70, "casual" => 22.13, "unknown" => 22.13 },
  #     "horticulture" => { "permanent" => 17.70, "casual" => 22.13, "unknown" => 22.13 },
  #     "meat" => { "permanent" => 17.70, "casual" => 22.13, "unknown" => 22.13 },
  #     "poultry" => { "permanent" => 18.30, "casual" => 22.87, "unknown" => 22.87 },
  #     "storage" => { "permanent" => 18.91, "casual" => 23.64, "unknown" => 23.64 }
  #   },
  #   2015 => {
  #     "horticulture" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 },
  #     "meat" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 },
  #     "poultry" => { "casual" => 22.34, "permanent" => 17.87, "unknown" => 22.34 },
  #     "no_award" => { "casual" => 21.61, "permanent" => 17.29, "unknown" => 21.61 },
  #     "storage" => { "casual" => 23.09, "permanent" => 18.47, "unknown" => 23.09 }
  #   }, 2014 => {
  #     "horticulture" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 },
  #     "meat" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 },
  #     "poultry" => { "casual" => 21.79, "permanent" => 17.43, "unknown" => 21.79 },
  #     "no_award" => { "casual" => 21.09, "permanent" => 16.87, "unknown" => 21.09 },
  #     "storage" => { "casual" => 22.52, "permanent" => 18.02, "unknown" => 22.52 }
  #   }, 2013 => {
  #     "horticulture" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 },
  #     "meat" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 },
  #     "poultry" => { "casual" => 21.15, "permanent" => 16.92, "unknown" => 21.15 },
  #     "no_award" => { "casual" => 20.46, "permanent" => 16.37, "unknown" => 20.46 },
  #     "storage" => { "casual" => 21.87, "permanent" => 17.49, "unknown" => 21.87 }
  #   }, 2012 => {
  #     "horticulture" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 },
  #     "meat" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 },
  #     "poultry" => { "casual" => 20.61, "permanent" => 16.49, "unknown" => 20.61 },
  #     "no_award" => { "casual" => 19.95, "permanent" => 15.96, "unknown" => 19.95 },
  #     "storage" => { "casual" => 21.32, "permanent" => 17.05, "unknown" => 21.32 }
  #   }, 2011 => {
  #     "horticulture" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 },
  #     "meat" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 },
  #     "poultry" => { "casual" => 20.04, "permanent" => 16.03, "unknown" => 20.04 },
  #     "no_award" => { "casual" => 19.39, "permanent" => 15.51, "unknown" => 19.39 },
  #     "storage" => { "casual" => 20.71, "permanent" => 16.57, "unknown" => 20.71 }
  #   }, 2010 => {
  #     "horticulture" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 },
  #     "meat" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 },
  #     "poultry" => { "casual" => 19.38, "permanent" => 15.50, "unknown" => 19.38 },
  #     "no_award" => { "casual" => 18.75, "permanent" => 15.00, "unknown" => 18.75 },
  #     "storage" => { "casual" => 20.03, "permanent" => 16.03, "unknown" => 20.03 }
  #   }
  # }
end
