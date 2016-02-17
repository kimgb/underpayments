module FinancialYears
  # refine Date do
  def fy
    month <= 6 ? year - 1 : year
  end
  # end
  
  def beginning_of_fy
    (month <= 6 ? last_year : self).change(:month => 7).beginning_of_month
  end
  
  def end_of_fy
    (month <= 6 ? self : next_year).change(:month => 6).end_of_month
  end
end
