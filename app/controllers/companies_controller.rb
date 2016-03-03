class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :set_claim, only: [:new, :create]
  before_action :set_claim_company, only: [:edit, :update]
  before_action :authorise_admin!, except: [:new, :create, :edit, :update]

  # GET /companies/1
  def show
    redirect_to current_user
  end

  # GET /claims/1/companies/new
  def new
    @company = Company.new
    @claim_company = @company.claim_companies.build(claim: @claim)
  end

  # GET /companies/1/edit
  def edit
    
  end

  # POST /claims/1/companies
  # POST /claims/1/companies.json
  def create
    @company = Company.new(company_params)
    @claim_company = @company.claim_companies.build(claim_company_params.merge({ claim: @claim }))

    respond_to do |format|
      if @company.save && @claim.save
        format.html { redirect_to current_user, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to current_user, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end
  
  def set_claim_company
    @claim_company = ClaimCompany.where(claim: @claim, company: @company).first
  end

  def company_params
    params.require(:company).permit(:name, :contact, :abn, :phone, :email) #, claim_company: [:is_workplace, :is_employer])
  end
  
  def claim_company_params
    params.require(:company).require(:claim_company).permit(:is_workplace, :is_employer, :is_active)
    # company_params[:claim_company]
  end

  def authorise_owner!
    forbidden unless @company.users.include?(current_user)
  end
end
