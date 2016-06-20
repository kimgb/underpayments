class Admin::ClaimsController < Admin::BaseController
  before_action :set_claim, except: [:create]
  
  # POST /admin/claims
  def create
    @user = User.find(claim_params[:user_id])
    @claim = Claim.new(user: @user)
    
    @claim.save(validate: false)
    
    redirect_to admin_user_path(@claim.user), notice: "Added."
  end
  
  # GET /admin/claims/1/edit
  def edit
  end
  
  # PATCH/PUT /admin/claims/1
  def update
    @claim.assign_attributes(claim_params)
    @user = @claim.user
    locking = @claim.submitted_for_review && @claim.submitted_for_review_changed?
    new_note = @claim.status_changed? || @claim.explanation_changed?
    
    respond_to do |format|
      if @claim.save
        set_submission_date if locking
        @note = Note.create(summary: @claim.status, explanation: @claim.explanation, annotatable: @claim, author: current_user) if new_note
        
        format.html { redirect_to admin_user_path(@claim.user), notice: "Updated." }
      else
        format.html { render "admin/users/show" } #test this?
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
    params.require(:claim).permit(:user_id, :award, :weekly_hours, :hourly_pay, :payslips_received, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end
end
