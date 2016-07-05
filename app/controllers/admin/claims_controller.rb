class Admin::ClaimsController < Admin::BaseController
  before_action :set_claim, except: [:index, :create]
  
  # GET /admin/claims
  def index
    @claims = case params[:scope]
      when "submitted" then Claim.includes(:documents, :user).select(&:submitted?)
      when "completed" then Claim.includes(:documents, :user).select(&:ready_to_submit?).reject(&:submitted?)
      when "incomplete" then Claim.includes(:documents, :user).select(&:not_submitted?).reject(&:ready_to_submit?)
      else Claim.includes(:documents, :user).select(&:submitted?)
    end
    
    @view_context = case params[:scope]
      when "incomplete" then "incomplete_review"
      else "complete_review"
    end
  end
  
  # GET /admin/claims/1
  def show    
  end
  
  # POST /admin/claims
  def create
    @user = User.find(claim_params[:user_id])
    @claim = Claim.new(user: @user)
    
    @claim.save(validate: false)
    
    redirect_to [:admin, @claim], notice: "Added."
  end
  
  # GET /admin/claims/1/edit
  def edit
  end
  
  # PATCH/PUT /admin/claims/1
  def update
    new_note = claim_params[:status].present? && claim_params[:comment].present? && 
      (claim_params[:status] != @claim.status || claim_params[:comment] != @claim.comment)
    @claim.assign_attributes(claim_params)
    @user = @claim.user
    locking = @claim.submitted_for_review && @claim.submitted_for_review_changed?
    
    respond_to do |format|
      if @claim.save
        set_submission_date if locking
        @claim.notes.create(summary: @claim.status, explanation: @claim.comment, author: current_user) if new_note
        
        format.html { redirect_to [:admin, @claim], notice: "Updated." }
      else
        format.html { render "admin/claims/show" } #test this?
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_claim
    @claim = Claim.find(params[:id])
  end
  
  def set_submission_date
    @claim.update_attribute(:submitted_on, DateTime.now)
  end

  def claim_params
    params.require(:claim).permit(:user_id, :award_id, :weekly_hours, :hourly_pay, :payslips_received, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end
end
