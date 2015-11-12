class EmployersController < ApplicationController
  before_action :set_employer, only: [:show, :edit, :update, :destroy]
  before_action :set_claim, only: [:new, :create]

  # GET /claims/1
  def show
    redirect_to @employer.claim.user
  end

  # GET /users/1/claims/new
  def new
    @employer = Employer.new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  # POST /claims.json
  def create
     @employer = @claim.build_employer(employer_params)

    respond_to do |format|
      if @employer.save && @claim.save
        format.html { redirect_to @claim.user, notice: 'Employer was successfully created.' }
        format.json { render :show, status: :created, location: @claim.user }
      else
        format.html { render :new }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claims/1
  # PATCH/PUT /claims/1.json
  def update
    respond_to do |format|
      if @employer.update(employer_params)
        format.html { redirect_to @user, notice: 'Employer was successfully updated.' }
        format.json { render :show, status: :ok, location: @employer.claim.user }
      else
        format.html { render :edit }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claims/1
  # DELETE /claims/1.json
  def destroy
    @employer.destroy
    respond_to do |format|
      format.html { redirect_to @employer.claim.user, notice: 'Employer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_employer
    @employer = Employer.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def employer_params
    params.require(:employer).permit(:name, :abn, :phone, :email)
  end
end