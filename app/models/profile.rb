class Profile < ActiveRecord::Base
  include Markdownable
  
  belongs_to :user
  belongs_to :address
  
  accepts_nested_attributes_for :address
  
  validates_presence_of :family_name, :given_name, :phone, :date_of_birth, 
    :nationality, :visa
    
  alias_method :done?, :valid?

  def self.presentable_attributes
    super.reject do |attr|
      ["gender", "visa", "nationality"].include? attr 
    end
  end

  def full_name
    [(preferred_name || given_name), family_name].join(" ")
  end
  
  def proper_full_name
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
    I18n.t('helpers.addresses.country_list')[nationality.to_sym]
  end
  
  def join_form_params
    { 
      "first_name" => given_name,
      "last_name" => family_name,
      "preferred_name" => preferred_name,
      "mobile" => phone,
      "dob" => date_of_birth.strftime("%Y/%m/%d"),
      "gender" => gender
    }.merge(address && address.join_form_params || {})
  end
end
