class Admin::ClaimsController < Admin::BaseController
  before_action :set_claim, except: [:index, :create]
  
  # GET /admin/claims
  def index
    @claim_search = ClaimSearch.new(claim_search_params)

    @claims = @claim_search.claims
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
    new_note?
    
    @claim.assign_attributes(claim_params)
    @user = @claim.user
    locking?
    
    respond_to do |format|
      if @claim.save
        set_submission_date if locking?
        create_note if new_note?
        
        format.html { redirect_to [:admin, @claim], notice: "Updated." }
        format.json { render :show, status: :ok, location: [:admin, @claim] }
      else
        format.html { render "admin/claims/show" } #test this?
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def new_note?
    @new_note ||= (claim_params[:claim_status_id].present? && 
      claim_params[:claim_status_id] != @claim.claim_status_id) ||
      (claim_params[:comment].present? && claim_params[:comment] != @claim.comment)
  end
  
  def create_note
    @claim.notes.create(summary: @claim.status, explanation: @claim.comment, author: current_user)
  end
  
  def locking?
    @locking ||= @claim.submitted_for_review && @claim.submitted_for_review_changed?
  end
  
  def set_claim
    @claim = Claim.find(params[:id])
  end
  
  def set_submission_date
    @claim.update_attribute(:submitted_on, DateTime.now)
  end
  
  def claim_search_params
    ActionController::Parameters.new(
      { user: current_user }.merge(params.fetch(:claim_search, {}).permit(
        :keywords, :point_person, :include_members, :include_non_members)
      )
    )
  end

  def claim_params
    params.require(:claim).permit(:user_id, :point_person_id, :award_id, 
      :time_period, :hours_per_period, :pay_period, :pay_per_period, 
      :payslips_received, :employment_began_on, :employment_ended_on, 
      :employment_type, :regular_hours, :exemplary_week, :claim_stage_id, 
      :comment, :review_date, :submitted_for_review, :hours_self_witnessed, 
      :pieceworker)
  end
end
