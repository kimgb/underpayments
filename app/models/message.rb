# not persisted to database (does not inherit from ActiveRecord).
class Message < ActiveRecord::Base
  include Tokenable
  after_create :fill_bodies!
  
  belongs_to :claim
  belongs_to :parent_message, class_name: "Message", foreign_key: "parent_message_id"
  has_many :replies, class_name: "Message" , foreign_key: "parent_message_id"

  attr_accessor :unlock  
  
  def tokenize_sender!
    sender_with_token = route_to_mailgun(tokenize(self.sender))
    
    self.update_attributes(sender: sender_with_token)
  end
  
  def intended_recipient
    email_has_token?(recipient) ? detokenize(recipient) : recipient
  end
  
  def original_sender
    email_has_token?(sender) ? detokenize(sender) : sender
  end
  
  def responder_token
    if token_idx = recipient =~ /\+/
      token_end_idx = recipient =~ /[@=]/
      recipient[token_idx+1..token_end_idx-1]
    end
  end
  
  private
  def email_has_token?(email)
    email.end_with?("@mg.nuw.org.au") && email =~ /\+/ && email =~ /[=]/
  end
  
  def tokenize(email)
    localpart, domain = email.split("@")
    localpart += "+#{self.token}"
    
    [localpart, domain].join("@")
  end
  
  def route_to_mailgun(email)
    email.gsub("@", "=") + "@mg.nuw.org.au"
  end
  
  def detokenize(tokenized_email)
    # Last gsub intended to remove token, may need testing
    tokenized_email.split("@")[0].gsub("=", "@").gsub(/(\+[^@]*)/, "")
  end
  
  def fill_bodies!
    update_attributes(
      stripped_plain: (stripped_plain || full_plain),
      full_html: (full_html || full_plain.gsub(/\r?\n/, "<br/>")),
      stripped_html: (stripped_html || full_plain.gsub(/\r?\n/, "<br/>"))
    )
  end
end
