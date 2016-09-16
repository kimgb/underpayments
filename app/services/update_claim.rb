require_relative 'application_service'

# Example usage:
# UpdateClaimStage.new(user: current_user, claim: @claim).call(params)
class UpdateClaim < ApplicationService
  attr_reader :user, :claim, :params
  
  def initialize(user:, claim:)
    @user, @claim = user, claim
  end
  
  def call(params)
    @params = ActionController::Parameters.new(params)
    
    unless user.owns?(claim)
      return Error.new(data: claim, message: "User lacks authority to make this update.")
    end
    
    claim.assign_attributes(claim_params)
    
    claim_submitted?
    notify_claimant?
    
    claim.submitted_on = DateTime.now if claim_submitted?
    
    if claim.save
      UserMailer.notify_point_person(claim).deliver_later
      UserMailer.submission_email(claim).deliver_later if claim_submitted?
      UserMailer.notify_stage_change(claim).deliver_later if notify_claimant?
      
      msg = claim_submitted? ? "Your claim has been submitted for review and is now locked for editing." : "Claim updated."
      
      Success.new(data: claim, message: msg) 
    else Error.new(data: claim, message: "Claim failed to save.") end
  end
  
  private
  def claim_params
    params.require(:claim).permit(:user_id, :point_person_id, :award_id, 
      :time_period, :hours_per_period, :pay_period, :pay_per_period, 
      :payslips_received, :employment_began_on, :employment_ended_on, 
      :employment_type, :regular_hours, :exemplary_week, :claim_stage_id, 
      :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end
  
  def claim_submitted?
    @claim_submitted ||= claim.submitted_for_review_changed?(to: true)
  end
  
  def notify_claimant?
    @notify_claimant ||= claim.claim_stage_id_changed? && 
      params[:notify_claimant].present?
  end
end

  # Claim Stages Notifications
  # When should claimants receive updates on their progress?
  # => Your claim has been seen & assigned to a point person
    # => "xyz will be managing your claim"
  # => We're waiting on information from you!
  # => Letter of demand is away
  # => Company has rejected your claim
  # => Company has requested further information
  # => Company has accepted your claim
  # => Court lodgement
  # => Court date received
  # => Court rejected your claim
  # => Court accepted your claim
