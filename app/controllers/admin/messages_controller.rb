class Admin::MessagesController < Admin::BaseController
  before_action :set_user

  # GET /admin/users/1/messages/new
  def new
    @message = Message.new
  end

  # POST /admin/users/1/messages
  def create
    @message = Message.new(message_params)
    UserMailer.generic_email_with_token(@user, current_user, @message).deliver_now

    redirect_to admin_user_path(@user), notice: "Message sent."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  def message_params
    params.require(:message).permit(:subject, :body)
  end
end
