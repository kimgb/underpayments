class GroupAward < ActiveRecord::Base
  belongs_to :group, inverse_of: :group_awards
  belongs_to :award, inverse_of: :group_awards
  
  validates_presence_of :display_text
  
  default_scope { includes(:award, :group) }
end
