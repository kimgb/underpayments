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

  def owners
    [user]
  end
  
  def visa_string_for_statement
    case visa
    when "citizen" then I18n.t('models.profile.visas.citizen')
    when "resident" then I18n.t('models.profile.visas.resident')
    when "unknown" then I18n.t('models.profile.visas.unknown')
    when "other" then I18n.t('models.profile.visas.other')
    else I18n.t('models.profile.visas.named', visa: I18n.t("helpers.profiles.visas_list.#{visa}")) end
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
