class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  belongs_to :supergroup
  delegate :name, to: :supergroup, prefix: "owner", allow_nil: true
  store_accessor :skin, 
    :text_color, :headings_color, :link_color, :background_color
  
  # Simplify changes to customisation with method_missing.
  # def method_missing(method, *args, &block)
  #   if value = skin[method.to_s]
  #     return value
  #   else
  #     raise(NoMethodError, "undefined method `#{method}' for #{self.to_s}")
  #   end
  # end
end
