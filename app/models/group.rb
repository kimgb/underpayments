class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :supergroup
  
  def color
    skin["text-color"]
  end
end
