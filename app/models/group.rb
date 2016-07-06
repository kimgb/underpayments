class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  store_accessor :skin, 
    :body_bg_color, :body_text_color, :headings_color, :link_color,
    :nav_bg_color, :nav_text_color, :btn_bg_color, :btn_text_color
  
  belongs_to :supergroup
  has_many :users
  
  delegate :name, to: :supergroup, prefix: "owner", allow_nil: true
  
  def awards_for_select
    awards.to_a.map(&:reverse).map { |str, k| [str, Award.friendly.find(k).id] }
  end
  
  def awards_blank_or_singleton?
    awards.blank? || awards.size == 1
  end
  
  def singleton_award
    awards.keys.first || "no_award" #National Employment Standards
  end
end
