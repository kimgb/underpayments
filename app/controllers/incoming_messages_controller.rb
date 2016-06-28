class IncomingMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, :set_locale, :authenticate_user!
  
  # POST /incoming_messages
  def create
    notifier = Slack::Notifier.new(ENV["slack_webhook_url"], channel: '#development')
    
    @message = Message.new(transform_message_params)
    @message.parent_message = Message.find_by_token(@message.responder_token)
    @message.claim = @message.parent_message.claim if @message.parent_message
    
    notifier.ping "Underpayments: A message was received from #{@message.original_sender}, for #{@message.intended_recipient} with the subject #{@message.subject}."
    
    @message.tokenize_sender!
    UserMailer.generic_email_with_token(@message.intended_recipient, @message.sender, 
      @message.subject, @message.full_plain).deliver_now
    
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
    params.permit(:recipient, :sender, :subject, :from, :sent_at, 
      :"stripped-text", :"body-plain", :"body-html", :"stripped-html")
  end
  
  def transform_message_params
    t_params = message_params.dup
    lookup = { full_plain: :"body-plain", full_html: :"body-html", sent_at: :timestamp,
      stripped_plain: :"stripped-text", stripped_html: :"stripped-html" }
    lookup.each { |key, p_key| t_params[key] = t_params.delete(p_key) }
    t_params[:sent_at] = DateTime.strptime("#{t_params[:sent_at]}", '%s') rescue DateTime.now
    
    t_params
  end
end
