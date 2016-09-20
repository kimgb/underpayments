class ClaimStage < ActiveRecord::Base
  has_many :claims
  translates :display_name, :notification_text
  
  def to_s
    display_name
  end
end
