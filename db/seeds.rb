# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Admin.new(email: "kbuckley@nuw.org.au", password: "ch3ng4M1chANGEmePrEtTYplz")
admin.save!

user = User.new(family_name: "Buckley", given_name: "Kim", email: "kbuckley@nuw.org.au", phone: "0424897579", date_of_birth: "1985-07-23", preferred_language: "en-AU")
user.password = "ch3ng4M1chANGEmePrEtTYplz"
user.save!

home_address = Address.new(street_address: "106/7 Warrs Ave", town: "Preston", province: "VIC", postal_code: "3072", country: "Australia")
home_address.addressable = user
home_address.save!

claim = Claim.new(award: "horticulture", total_hours: 1234, hourly_pay: 11.23, employment_type: "casual")
claim.user = user
claim.save!

# start_page = Page.new(
#   title: "Am I Underpaid?",
#   slug: "start",
#   content: File.read(Rails.root + "db" + "pages" + "start.html")
# )
# start_page.save!
