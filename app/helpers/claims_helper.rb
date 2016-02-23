module ClaimsHelper
  def claims_lower_bound_year
    [Date.today.year - 7, 2010].max
  end
end
