class Supergroup < ActiveRecord::Base
  include PgSearch

  has_many :groups
  has_many :users
  
  pg_search_scope(
    :search,
    against: %i(name short_name),
    using: { tsearch: { dictionary: "english" } }
  )
end
