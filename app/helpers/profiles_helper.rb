module ProfilesHelper
  def profiles_lower_bound_year
    Date.today.year - 100
  end
  
  def visas_list
    [
      ["I don't know", "unknown"],
      ["400 - Temporary Work (Short Stay Activity) visa", "400"], 
      ["416 - Special Program visa for the seasonal worker programme", "416"], 
      ["417 - Working Holiday visa", "417"], 
      ["444 - Special Category visa for New Zealand citizens", "444"], 
      ["457 - Temporary Work - Skilled visa", "457"], 
      ["461 - New Zealand Citizen Family Relationship temporary visa", "461"], 
      ["186 - Employer Nomination Scheme", "186"], 
      ["187 - Regional Sponsored Migration Scheme visa", "187"], 
      ["189 - Skilled Independent visa", "189"], 
      ["190 - Skilled Nominated visa", "190"], 
      ["201 - In-country Special Humanitarian visa", "201"], 
      ["202 - Global Special Humanitarian visa", "202"], 
      ["203 - Emergency Rescue visa", "203"], 
      ["204 - Woman at risk visa", "204"] 
    ]
  end
  
  def country_list
    [ 
      ["Australia", "AU"], 
      ["New Zealand", "NZ"], 
      ["Tonga", "TO"], 
      ["Fiji", "FJ"], 
      ["Taiwan", "TW"], 
      ["Samoa", "WS"], 
      ["Kiribati", "KI"], 
      ["Nauru", "NR"], 
      ["Papua New Guinea", "PG"], 
      ["Solomon Islands", "SB"], 
      ["Timor-Leste", "TL"], 
      ["Tuvalu", "TV"], 
      ["Vanuatu", "VU"]
    ]
  end
  
  def gender_list
    [ 
      ["I'd rather not say", "U"], 
      ["Female", "F"], 
      ["Male", "M"], 
      ["It's not that simple", "O"] 
    ]
  end
end
