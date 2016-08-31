class FeedbackController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_checkpoint, only: [:new]

  # GET /feedback/new
  def new
    @feedback = Feedback.new(sender: current_user.try(:email))
  end

  # POST /feedback
  def create
    @feedback = Feedback.new(feedback_params)
    
    if @feedback.valid?
      UserMailer.feedback_email(@feedback.attributes).deliver_later
      redirect_to checkpoint, notice: "Feedback is on its way!"
    else
      render :new
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:sender, :body)
  end
end
