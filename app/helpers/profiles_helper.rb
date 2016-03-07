module ProfilesHelper
  def lower_bound_birth_year
    Date.today.year - 100
  end
  
  def upper_bound_birth_year
    Date.today.year - 14
  end
  
  def languages_list
    locale_list_for_select_options('helpers.profiles.languages_list')
  end
  
  def visas_list
    locale_list_for_select_options('helpers.profiles.visas_list')
  end
  
  def country_list
    locale_list_for_select_options('helpers.profiles.country_list')
  end
  
  def gender_list
    [ 
      [I18n.t('helpers.profiles.gender_list.refused'), "U"], 
      [I18n.t('helpers.profiles.gender_list.female'), "F"], 
      [I18n.t('helpers.profiles.gender_list.male'), "M"], 
      [I18n.t('helpers.profiles.gender_list.neither'), "N"] 
    ]
  end
  
  private
  def locale_list_for_select_options(locale_string)
    I18n.t(locale_string).stringify_keys.to_a.map(&:reverse)
  end
end
