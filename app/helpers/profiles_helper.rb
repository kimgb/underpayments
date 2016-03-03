module ProfilesHelper
  def profiles_lower_bound_year
    Date.today.year - 100
  end
  
  def languages_list
    [
      [I18n.t('helpers.profiles.languages_list.en-AU'), "en-AU"],
      [I18n.t('helpers.profiles.languages_list.zh-TW'), "zh-TW"],
      [I18n.t('helpers.profiles.languages_list.vi'), "vi"]
    ]
  end
  
  def visas_list
    [
      [I18n.t('helpers.profiles.visas_list.resident'), "resident"],
      [I18n.t('helpers.profiles.visas_list.unknown'), "unknown"],
      [I18n.t('helpers.profiles.visas_list.v400'), "400"], 
      [I18n.t('helpers.profiles.visas_list.v416'), "416"], 
      [I18n.t('helpers.profiles.visas_list.v417'), "417"], 
      [I18n.t('helpers.profiles.visas_list.v444'), "444"], 
      [I18n.t('helpers.profiles.visas_list.v457'), "457"], 
      [I18n.t('helpers.profiles.visas_list.v201'), "201"], 
      [I18n.t('helpers.profiles.visas_list.v202'), "202"], 
      [I18n.t('helpers.profiles.visas_list.v203'), "203"], 
      [I18n.t('helpers.profiles.visas_list.v204'), "204"],
      [I18n.t('helpers.profiles.visas_list.other'), "other"]
    ]
  end
  
  def country_list
    [ 
      [I18n.t('helpers.profiles.country_list.australia'), "AU"], 
      [I18n.t('helpers.profiles.country_list.new_zealand'), "NZ"], 
      [I18n.t('helpers.profiles.country_list.tonga'), "TO"], 
      [I18n.t('helpers.profiles.country_list.fiji'), "FJ"], 
      [I18n.t('helpers.profiles.country_list.taiwan'), "TW"], 
      [I18n.t('helpers.profiles.country_list.samoa'), "WS"], 
      [I18n.t('helpers.profiles.country_list.kiribati'), "KI"], 
      [I18n.t('helpers.profiles.country_list.nauru'), "NR"], 
      [I18n.t('helpers.profiles.country_list.papua_new_guinea'), "PG"], 
      [I18n.t('helpers.profiles.country_list.solomon_islands'), "SB"], 
      [I18n.t('helpers.profiles.country_list.east_timor'), "TL"], 
      [I18n.t('helpers.profiles.country_list.tuvalu'), "TV"], 
      [I18n.t('helpers.profiles.country_list.vanuatu'), "VU"]
    ]
  end
  
  def gender_list
    [ 
      [I18n.t('helpers.profiles.gender_list.refused'), "U"], 
      [I18n.t('helpers.profiles.gender_list.female'), "F"], 
      [I18n.t('helpers.profiles.gender_list.male'), "M"], 
      [I18n.t('helpers.profiles.gender_list.neither'), "N"] 
    ]
  end
end
