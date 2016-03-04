class Profile < ActiveRecord::Base
  include Markdownable
  
  belongs_to :user
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  validates_presence_of :family_name, :given_name, :phone, :date_of_birth, 
    :nationality
    
  alias_method :done?, :valid?

  def self.presentable_attributes
    super.reject do |attr| 
      ["gender", "visa", "nationality"].include? attr 
    end
  end

  def full_name
    [given_name, family_name].join(" ")
  end

  def owner
    user
  end
  
  def visa_string_for_statement
    case visa
    when "resident" then "I am a citizen or permanent resident of Australia"
    when "unknown" then "I am not aware of my visa status."
    when "other" then "I came to Australia on a [please fill in] visa."
    else "I came to Australia on a #{visa} visa." end
  end
  
  def country_of_origin
    {
      "AU" => "Australia",
      "NZ" => "New Zealand",
      "TO" => "Tonga",
      "FJ" => "Fiji",
      "TW" => "Republic of China",
      "WS" => "Samoa",
      "KI" => "Kiribati",
      "NR" => "Nauru",
      "PG" => "Papua New Guinea",
      "SB" => "Solomon Islands",
      "TL" => "Timor-Leste",
      "TV" => "Tuvalu",
      "VU" => "Vanuatu"
    }[nationality]
  end
end
