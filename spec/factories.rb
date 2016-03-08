FactoryGirl.define do
  factory :user do
    email     "user@nuw.org.au"
    password  "password"
    admin     false
  end

  factory :session_user, class: User do
    email     "session@nuw.org.au"
    password  "password"
    admin     false
  end

  factory :admin, class: User do
    email     "admin@nuw.org.au"
    password  "password"
    admin     true
  end

  factory :session_admin, class: User do
    email     "sa@nuw.org.au"
    password  "password"
    admin     true
  end

  factory :profile do
    family_name         "Casey"
    given_name          "Tess"
    phone               "0401247359"
    date_of_birth       Date.new(1996, 4, 2)
    preferred_language  "en-AU"
    user
  end

  factory :address do
    street_address  "833 Bourke St"
    town            "Docklands"
    province        "VIC"
    postal_code     "3008"
    country         "AU"
  end

  factory :updated_address, class: Address do
    street_address  "889 Collins St"
    town            "Docklands"
    province        "VIC"
    postal_code     "3008"
    country         "AU"
  end

  factory :invalid_address, class: Address do
    street_address  "833 Bourke St"
    town            nil
    province        "VIC"
    postal_code     "3008"
    country         "AU"
  end

  factory :claim do
    award               "horticulture"
    hourly_pay          11.23
    weekly_hours        35
    employment_began_on Date.new(2015, 7, 1)
    employment_ended_on Date.new(2016, 1, 31)
    employment_type     "casual"
    # association     :user, strategy: :build
    # association     :address, strategy: :build
  end

  factory :claim_with_user, class: Claim do
    award               "horticulture"
    hourly_pay          11.23
    weekly_hours        35
    employment_began_on Date.new(2015, 7, 1)
    employment_ended_on Date.new(2016, 1, 31)
    employment_type     "casual"
    user
  end

  factory :document do
    statement           "My statement, signed Factory Girl"
    wage_evidence       true
    time_evidence       true
    coverage_start_date Date.new(2015, 8, 1)
    coverage_end_date   Date.new(2015, 10, 31)
    claim
  end
  
  factory :claim_company do
    is_active           true
    is_employer         true
    is_workplace        true
    company
    association :claim, factory: :claim_with_user
  end

  factory :company do
    name    "NUW"
    contact "lrohde"
    phone   "0392871777"
    email   "info@nuw.org.au"
  end
end
