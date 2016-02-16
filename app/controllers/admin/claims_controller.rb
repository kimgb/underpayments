class Admin::ClaimsController < Admin::BaseController
  before_action :set_claim

  # PATCH/PUT /admin/claims/1
  def update
    @claim.update_attributes(claim_params)

    redirect_to admin_user_path(@claim.user), notice: "Status updated"
  end

  private
  def set_claim
    @claim = Claim.find(params[:id])
  end

  def claim_params
    params.require(:claim).permit(:status, :comment)
  end
end
