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
    @claim.update_attributes(claim_params)

    redirect_to admin_user_path(@claim.user), notice: "Updated."
  end

  private
  def set_claim
    @claim = Claim.find(params[:id])
  end

  def claim_params
    params.require(:claim).permit(:user_id, :award, :weekly_hours, :hourly_pay, :payslips_received, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end
end
