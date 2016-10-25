# lib/financial_years.rb
# Adds a few methods to Date to handle Australian financial year logic.
# Financial years in this module are forward-dated to the year they end in.
# E.g. financial year 2015 -> 1 July 2014 to 30 June 2015

module FinancialYears
  # refine Date do
  def fy
    month <= 6 ? year - 1 : year
  end
    
  def beginning_of_fy
    (month <= 6 ? last_year : self).change(month: 7, day: 1)
  end
  
  def end_of_fy
    (month <= 6 ? self : next_year).change(month: 6, day: 30)
  end
end
