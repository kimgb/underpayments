class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :supergroup
  has_many :users
  delegate :name, to: :supergroup, prefix: "owner", allow_nil: true
  store_accessor :skin, 
    :body_bg_color, :body_text_color, :headings_color, :link_color,
    :nav_bg_color, :nav_text_color, :btn_bg_color, :btn_text_color
  
  # Simplify changes to customisation with method_missing.
  # def method_missing(method, *args, &block)
  #   if value = skin[method.to_s]
  #     return value
  #   else
  #     raise(NoMethodError, "undefined method `#{method}' for #{self.to_s}")
  #   end
  # end
end
