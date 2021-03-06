module AddressesHelper
  # def form_title
  #   (@address.addressable || @addressable).class.to_s.downcase + "_title"
  # end

  def markdown_postal_format(addressee, address)
    [
      addressee,
      address.street_address.gsub(/(\r?\n)/, '  \1'),
      address.town,
      address.province + "&emsp;" + address.postal_code
    ].reject(&:blank?).join("  \n")
  end
  
  def states_list
    locale_list_for_select_options('helpers.addresses.states_list')
  end
  
  def full_country_list
    locale_list_for_select_options('helpers.addresses.country_list')
  end
end
