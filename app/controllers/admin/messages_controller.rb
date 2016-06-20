class Admin::MessagesController < Admin::BaseController
  before_action :set_claim
  
  # GET /admin/claims/1/messages
  def index
    @messages = @claim.messages
  end

  # GET /admin/claims/1/messages/new
  def new
    @message = Message.new
  end

  # POST /admin/claims/1/messages
  def create
    @message = Message.new(message_params)
    @message.sender = current_user.email
    @message.tokenize_sender!

    @message.recipient = @claim.user.email
    @message.claim = @claim
    
    if @message.save
      UserMailer.generic_email_with_token(@message.recipient, @message.sender, 
        @message.subject, @message.full_plain).deliver_now
      
      @message.update_attributes(sent_at: Time.now.to_i)
      if unlock_claim? && @claim.present?
        @claim.update_attributes(submitted_for_review: false)
      end
      
      redirect_to admin_user_path(@claim.user), notice: "Message sent."
    else
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def message_params
    params.require(:message).permit(:subject, :full_plain)
  end
  
  def unlock_claim?
    params.dig(:message, :unlock)
  end
end
