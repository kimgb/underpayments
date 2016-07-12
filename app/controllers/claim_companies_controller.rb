class ClaimCompaniesController < ApplicationController
  before_action :authenticate_user!
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
    @claim_company = ClaimCompany.new(claim_company_params)
    @claim_company.build_company
  end

  # GET /claim_companies/1/edit
  def edit
  end

  # POST /claims/1/claim_companies
  # POST /claims/1/claim_companies.json
  def create
     @claim_company = @claim.claim_companies.build(claim_company_params) do |cc|
       cc.build_company(company_params) if cc.company.blank? && company_params.any?
     end

    respond_to do |format|
      if @claim.save
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
        @claim_company.claim.save
        
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
    respond_to do |format|
      if @claim_company.update(is_active: false)
        @claim_company.claim.save
        
        format.html { redirect_to current_user, notice: 'Company was successfully removed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to current_user, notice: 'Company could not be removed.' }
        format.json { render json: @claim_company.errors, status: :unprocessable_entity }
      end
    end
  end

  private
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
    params.fetch(:claim_company, {}).permit(:is_employer, :is_workplace, :is_active, :claim_id, :company_id)
  end
  
  def company_params
    params.fetch(:claim_company, {}).require(:company_attributes).permit(:name, :contact, :abn, :email, :phone)
    # claim_company_params[:company_attributes]
  end

  def authorise_owner!
    forbidden unless @claim_company.users.include?(current_user)
  end
end
