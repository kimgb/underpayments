class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, :set_locale, :authenticate_user!
  
  # POST /incoming_messages
  def create
    notifier = Slack::Notifier.new(ENV["slack_webhook_url"], channel: '#development')
    
    @message = Message.new(transform_message_params)
    @message.parent_message = Message.find_by_token(@message.responder_token)
    @message.claim = @message.parent_message.claim if @message.parent_message
    
    notifier.ping @message.to_json
    
    respond_to do |format|
      if @message.save
        format.json { render json: @message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  def message_params
    params.permit(:recipient, :sender, :subject, :from, :timestamp, 
      :"stripped-text", :"body-plain", :"body-html", :"stripped-html")
  end
  
  def transform_message_params
    t_params = message_params.dup
    lookup = { full_plain: :"body-plain", full_html: :"body-html", 
      stripped_plain: :"stripped-text", stripped_html: :"stripped-html" }
    lookup.each { |key, p_key| t_params[key] = t_params.delete(p_key) }
    
    t_params
  end
end
