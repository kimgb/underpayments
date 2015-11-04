json.array!(@users) do |user|
  json.extract! user, :id, :family_name, :given_name, :email, :phone, :country, :postal_code, :province, :town, :street_address, :secondary_street_address, :preferred_language
  json.url user_url(user, format: :json)
end
