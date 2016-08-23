class FeedbackController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /feedback/new
  def new
  end

  # POST /feedback
  def create
    sender = feedback_params[:sender] || current_user.try(:email)

    if sender
      UserMailer.feedback_email(sender, feedback_params[:body]).deliver_later
    end

    redirect_to "/", notice: "Feedback is on its way!"
  end

  private
  def feedback_params
    params.require(:feedback).permit(:sender, :body)
  end
end
