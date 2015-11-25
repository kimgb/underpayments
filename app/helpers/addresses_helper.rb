module AddressesHelper
  def form_title
    (@address.addressable || @addressable).class.to_s.downcase + "_title"
  end
end
