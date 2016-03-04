class ClaimCompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :new_claim_company, only: [:new]
  before_action :set_claim_company, only: [:show, :edit, :update, :destroy]
  before_action :set_claim, only: [:new, :create]
  before_action :set_company, only: [:edit, :update]
  # before_action :authorise_admin!, except: [:new, :create, :edit, :update]

  # GET /claim_companies/1
  def show
    redirect_to current_user
  end

  # GET /claims/1/claim_companies/new
  def new
    @claim_company.build_company
  end

  # GET /claim_companies/1/edit
  def edit
  end

  # POST /claims/1/claim_companies
  # POST /claims/1/claim_companies.json
  def create
     @claim_company = @claim.claim_companies.build(claim_company_params)
     @claim_company.build_company(company_params) if company_params.any?

    respond_to do |format|
      if @claim_company.save
        format.html { redirect_to @claim.user, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @claim_company }
      else
        format.html { render :new }
        format.json { render json: @claim_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claim_companies/1
  # PATCH/PUT /claim_companies/1.json
  def update
    respond_to do |format|
      if @claim_company.update(claim_company_params) && @company.update(company_params)
        format.html { redirect_to current_user, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @claim_company.claim.user }
      else
        format.html { render :edit }
        format.json { render json: @claim_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claim_companies/1
  # DELETE /claim_companies/1.json
  def destroy
    @claim_company.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Company was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def new_claim_company
    @claim_company = ClaimCompany.new
  end
  
  def set_claim_company
    @claim_company = ClaimCompany.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end
  
  def set_company
    @company = @claim_company.company
  end

  def claim_company_params
    params.require(:claim_company).permit(:is_employer, :is_workplace, :is_active, company_attributes: [:id, :name, :contact, :abn, :phone, :email])
  end
  
  def company_params
    claim_company_params[:company_attributes]
  end

  def authorise_owner!
    forbidden unless @claim_company.users.include?(current_user)
  end
end
