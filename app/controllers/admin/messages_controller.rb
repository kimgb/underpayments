class Admin::MessagesController < Admin::BaseController
  before_action :set_user

  # GET /admin/users/1/messages/new
  def new
    @message = Message.new
  end

  # POST /admin/users/1/messages
  def create
    @message = Message.new(message_params)
    @message.sender = current_user.email
    @message.tokenize_sender!

    @message.recipient = @user.email
    @message.claim = @claim
    
    if @message.save
      UserMailer.generic_email_with_token(@message.recipient, @message.sender, 
        @message.subject, @message.full_plain).deliver_now
      
      @message.update_attributes(sent_at: Time.now.to_i)
      @claim.update_attributes(submitted_for_review: false) if unlock_claim?
      
      redirect_to admin_user_path(@user), notice: "Message sent."
    else
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
    @claim = @user.claim if @user
  end

  def message_params
    params.require(:message).permit(:subject, :full_plain)
  end
  
  def unlock_claim?
    params.dig(:message, :unlock)
  end
end
