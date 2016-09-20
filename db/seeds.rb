# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
sg = Supergroup.create(
  name: "National Union of Workers",
  short_name: "NUW",
  description: "The NUW is a progressive, private sector union covering a range of industries, pushing hard for a better working life in Australia.",
  www: "https://www.nuw.org.au/"
)

grp = Group.create(
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
  supergroup: sg,
  awards: { "nes" => "I'm not sure", "horticulture" => "Horticulture, e.g. fruit picking", "meat" => "Meat industry", "poultry" => "Poultry processing", "storage" => "Packing, storage etc." }
)

user = User.new(
  email: "kbuckley@nuw.org.au",
  admin: true,
  group: grp
)
user.password = "ch3ng4M1chANGEmePrEtTYplz"
user.save!

home_address = Address.new(
  street_address: "833 Bourke St",
  town: "Docklands",
  province: "VIC",
  postal_code: "3008",
  country: "Australia"
)

profile = Profile.create(
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

# nes = Award.create(
# name: "National Employment Standards",
# short_name: "nes",
# default_minimum: BigDecimal.new(21.61, 10),
# min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
# min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 }
# )
#
# horticulture = Award.create(
# name: "Horticulture Award 2010",
# short_name: "horticulture",
# default_minimum: BigDecimal.new(21.61, 10),
# min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
# min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 }
# )
#
# meat = Award.create(
# name: "Meat Industry Award 2010",
# short_name: "meat",
# default_minimum: BigDecimal.new(21.61, 10),
# min_casual_rates: { "2016" => 22.13, "2015" => 21.61, "2014" => 21.09, "2013" => 20.46, "2012" => 19.95, "2011" => 19.39, "2010" => 18.75 },
# min_permanent_rates: { "2016" => 17.70, "2015" => 17.29, "2014" => 16.87, "2013" => 16.37, "2012" => 15.96, "2011" => 15.51, "2010" => 15.00 }
# )
#
# poultry = Award.create(
# name: "Poultry Processing Award 2010",
# short_name: "poultry",
# default_minimum: BigDecimal.new(22.34, 10),
# min_casual_rates: { "2016" => 22.87, "2015" => 22.34, "2014" => 21.79, "2013" => 21.15, "2012" => 20.61, "2011" => 20.04, "2010" => 19.38 },
# min_permanent_rates: { "2016" => 18.30, "2015" => 17.87, "2014" => 17.43, "2013" => 16.92, "2012" => 16.49, "2011" => 16.03, "2010" => 15.50 }
# )
#
# storage = Award.create(
# name: "Storage Services Award 2010",
# short_name: "storage",
# default_minimum: BigDecimal.new(23.09, 10),
# min_casual_rates: { "2016" => 23.64, "2015" => 23.09, "2014" => 22.52, "2013" => 21.87, "2012" => 21.32, "2011" => 20.71, "2010" => 20.03 },
# min_permanent_rates: { "2016" => 18.91, "2015" => 18.47, "2014" => 18.02, "2013" => 17.49, "2012" => 17.05, "2011" => 16.57, "2010" => 16.03 }
# )

claim = Claim.new(
  award: Award.first,
  hours_per_period: 35,
  time_period: "week",
  pay_per_period: 11.23,
  pay_period: "hour",
  employment_type: "casual",
  employment_began_on: Date.new(2015, 02, 01),
  employment_ended_on: Date.new(2015, 10, 01),
  user: user
)
