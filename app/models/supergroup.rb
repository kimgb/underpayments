class Supergroup < ActiveRecord::Base
  include PgSearch

  has_many :groups
  has_many :users, through: :groups
  
  pg_search_scope :search, against: %i(name short_name), 
    using: { 
      tsearch: { 
        prefix: true,
        dictionary: "english"
      } 
    }
end
