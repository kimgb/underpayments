class ClaimCompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_claim, only: [:new, :create]
  before_action :set_company, only: [:edit, :update, :destroy]

  # GET /claims/1/claim_companies/new
  def new
    @company = CompanyFacade.new(Company.new, @claim)
  end

  # GET /claim_companies/1/edit
  def edit
  end

  # POST /claims/1/claim_companies
  # POST /claims/1/claim_companies.json
  def create
    @company = CompanyFacade.new(Company.new, @claim)
    @company.attributes = company_params

    respond_to do |format|
      if @company.save!
        format.html { redirect_to @company.claim_user, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claim_companies/1
  # PATCH/PUT /claim_companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company.claim_user, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company.claim_user }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claim_companies/1
  # DELETE /claim_companies/1.json
  def destroy
    respond_to do |format|
      if @company.update(is_active: false)
        format.html { redirect_to @company.claim_user, notice: 'Company was successfully removed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @company.claim_user, notice: 'Company could not be removed.' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end
  
  def set_company
    @company = CompanyFacade.find(params[:id])
  end

  def company_params
    params.fetch(:company_facade, {}).permit(:is_employer, :is_workplace, :is_active, :claim_id, :company_id, :name, :contact, :abn, :email, :phone)
  end

  def authorise_owner!
    forbidden unless @company.users.include?(current_user)
  end
end
