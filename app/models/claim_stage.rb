class ClaimStage < ActiveRecord::Base
  enum category: %i(ongoing abandoned failed junk succeeded)
  
  has_many :claims
  translates :display_name, :notification_text
  
  def to_s
    display_name
  end
end
