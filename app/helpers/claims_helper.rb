module ClaimsHelper
  def claims_lower_bound_year
    [Date.today.year - 7, 2010].max
  end

  def employment_type_list
    locale_list_for_select_options('helpers.claims.employment_types')
  end
end
