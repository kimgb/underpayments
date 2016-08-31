class Feedback
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :sender, :body
  validates_presence_of :sender, :body

  def initialize(attrs = {})
    @sender = attrs[:sender]
    @body = attrs[:body]
  end
  
  def attributes
    { "sender" => sender, "body" => body }
  end
  
  def persisted?
    false
  end
end
