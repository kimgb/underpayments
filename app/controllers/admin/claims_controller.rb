class Admin::ClaimsController < Admin::BaseController
  before_action :set_claim
  
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
    params.require(:claim).permit(:award, :weekly_hours, :hourly_pay, :payslips_received, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end
end
