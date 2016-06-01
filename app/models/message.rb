# not persisted to database (does not inherit from ActiveRecord).
class Message < ActiveRecord::Base
  include Tokenable
  
  belongs_to :claim
  belongs_to :parent_message, class_name: "Message", foreign_key: "parent_message_id"
  has_many :replies, class_name: "Message" 

  attr_accessor :unlock  
  
  def responder_token
    if token_idx = recipient =~ /\+/
      token_end_idx = recipient =~ /@/
      recipient[token_idx+1..token_end_idx-1]
    end
  end
end
