class ClaimsController < ApplicationController
  before_action :set_claim, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create]
  before_action :authenticate_admin!, only: [:index]
  # set_employer?

  # GET /claims
  def index
    @claims = Claim.select(&:ready_to_submit?)
  end

  # GET /claims/1
  def show
    redirect_to @claim.user
  end

  # GET /users/1/claims/new
  def new
    @claim = Claim.new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  # POST /claims.json
  def create
     @claim = @user.build_claim(claim_params)

    respond_to do |format|
      if @claim.save
        format.html { redirect_to @user, notice: 'Claim was successfully created.' }
        format.json { render :show, status: :created, location: @user }
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
        format.html { redirect_to @claim.user, notice: 'Claim was successfully updated.' }
        format.json { render :show, status: :ok, location: @claim.user }
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
    params.require(:claim).permit(:award, :total_hours, :hourly_pay, :lost_wages, :employment_began_on, :employment_ended_on, :employment_type, :regular_hours, :exemplary_week, :status, :comment)
  end
end
