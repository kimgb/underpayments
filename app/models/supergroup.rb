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
    
  def point_people_for_select
    users.admin.map { |u| [(u.full_name || u.email), u.id] }
  end
end
