module AddressesHelper
  # def form_title
  #   (@address.addressable || @addressable).class.to_s.downcase + "_title"
  # end

  def markdown_postal_format(addressee, address)
    [
      addressee,
      address.street_address,
      address.town,
      address.province + "&emsp;" + address.postal_code
    ].reject(&:blank?).join("  \n")
  end
  
  def states_list
    [
      [I18n.t('helpers.addresses.states_list.ACT'), "ACT"],
      [I18n.t('helpers.addresses.states_list.NSW'), "NSW"],
      [I18n.t('helpers.addresses.states_list.NT'), "NT"],
      [I18n.t('helpers.addresses.states_list.QLD'), "QLD"],
      [I18n.t('helpers.addresses.states_list.SA'), "SA"],
      [I18n.t('helpers.addresses.states_list.TAS'), "TAS"],
      [I18n.t('helpers.addresses.states_list.VIC'), "VIC"],
      [I18n.t('helpers.addresses.states_list.WA'), "WA"]
    ]
  end
end
