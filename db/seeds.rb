# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
sg = Supergroup.new(
  name: "National Union of Workers", 
  short_name: "NUW",
  description: "The NUW is a progressive, private sector union covering a range of industries, pushing hard for a better working life in Australia.",
  www: "https://www.nuw.org.au/"
)
sg.save!

grp = Group.new(
  name: "Fair Food",
  skin: {
    "link_color" => "#F5003D",
    "headings_color" => "#0B8842",
    "body_text_color" => "#DDD",
    "body_bg_color" => "#161616",
    "btn_bg_color" => "#A9002A",
    "btn_text_color" => "#DDD",
    "nav_bg_color" => "#7B001F",
    "nav_text_color" => "#DDD"
  },
  supergroup: sg
)
grp.save!

user = User.new(
  email: "kbuckley@nuw.org.au", 
  admin: true, 
  group: grp
)
user.password = "ch3ng4M1chANGEmePrEtTYplz"
user.save!

home_address = Address.new(
  street_address: "106/7 Warrs Ave", 
  town: "Preston", 
  province: "VIC", 
  postal_code: "3072", 
  country: "Australia"
)
home_address.save!

profile = Profile.new(
  family_name: "Buckley", 
  given_name: "Kim", 
  preferred_name: "Kim",
  gender: "M",
  phone: "0400000000", 
  date_of_birth: "1980-01-01", 
  preferred_language: "en-AU", 
  nationality: "NZ", 
  visa: "v444",
  user: user,
  address: home_address
)
profile.save!

claim = Claim.new(
  award: "horticulture",
  weekly_hours: 35, 
  hourly_pay: 11.23, 
  employment_type: "casual", 
  employment_began_on: Date.new(2015, 02, 01), 
  employment_ended_on: Date.new(2015, 10, 01)
)
claim.user = user
claim.save!
