class ClaimsController < ApplicationController
  before_action :set_claim, only: [:show, :edit, :update, :destroy]
  before_action :authorise_admin!, only: [:index, :destroy]
  before_action :authorise_owner!, only: [:show, :edit, :update]
  before_action :confirm_unlocked!, only: [:edit, :update, :destroy]
  
  # set_employer?

  # GET /claims
  def index
    @claims = Claim.select(&:ready_to_submit?)
  end

  # GET /claims/1
  def show
    redirect_to @claim.user
  end

  # GET /claims/new
  def new
    redirect_to current_user if current_user && current_user.claim.present?

    @claim = Claim.new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  # POST /claims.json
  def create
    @claim = Claim.new(claim_params)
    @claim.user = current_user if current_user.present?

    respond_to do |format|
      if @claim.save
        session[:claim_id] = @claim.id unless current_user.present?

        format.html { redirect_to pages_path(page: "estimate", claim_id: @claim) }
        # format.html { redirect_to new_user_path, notice: 'Claim was successfully created.' }
        # format.js   {  }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claims/1
  # PATCH/PUT /claims/1.json
  def update
    respond_to do |format|
      if @claim.update(claim_params)
        if @claim.submitted_for_review
          set_submission_date
          UserMailer.submission_email.deliver_now
          
          format.html { redirect_to @claim.user, notice: 'Your claim has been submitted for review and is now locked for editing.' }
          format.json { render :show, status: :ok, location: @claim.user }
        else
          format.html { redirect_to @claim.user, notice: 'Claim was successfully updated.' }
          format.json { render :show, status: :ok, location: @claim.user }
        end
      else
        format.html { render :edit }
        format.json { render json: @claim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claims/1
  # DELETE /claims/1.json
  def destroy
    @claim.destroy
    respond_to do |format|
      format.html { redirect_to @claim.user, notice: 'Claim was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_submission_date
    @claim.update_attribute(:submitted_on, DateTime.now)
  end
  
  def set_claim
    @claim = Claim.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_employer
    @employer = Employer.find(params[:employer_id])
  end

  def claim_params
    params.require(:claim).permit(:award, :weekly_hours, :hourly_pay, :payslips_received, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment, :submitted_for_review, :hours_self_witnessed, :pieceworker)
  end

  def authorise_owner!
    forbidden! unless current_user && current_user.owns?(@claim)
  end
  
  def confirm_unlocked!
    forbidden! if @claim.locked? && !(current_user && current_user.admin?)
  end
end
