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
    
  # Used when assigning point person, and when searching claims
  def point_people_for_select
    users.admin.sort_by { |u| u.full_name || u.email }
      .map { |u| [(u.full_name || u.email), u.id] }
  end
end
