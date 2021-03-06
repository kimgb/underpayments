class Admin::ClaimCompaniesController < Admin::BaseController
  before_action :set_claim_company, only: [:destroy]
  before_action :set_claim, only: [:new, :create]

  # GET /admin/claims/1/claim_companies/new
  def new
    @claim_company = ClaimCompany.new(claim_company_params)
    @claim_company.build_company
  end

  # POST /admin/claims/1/claim_companies
  def create
    @claim_company = @claim.claim_companies.find_or_initialize_by(company_id: claim_company_params[:company_id])
    
    @claim_company.assign_attributes(claim_company_params.except(:is_employer, :is_workplace))
    @claim_company.is_employer = !!(@claim_company.is_employer? || claim_company_params[:is_employer] == "1")
    @claim_company.is_workplace = !!(@claim_company.is_workplace? || claim_company_params[:is_workplace] == "1")
    @claim_company.build_company(company_params) if @claim_company.company.blank? && company_params.any?
    
    respond_to do |format|
      if @claim.save && @claim_company.save
        format.html { redirect_to [:admin, @claim], notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @claim_company }
      else
        format.html { render :new }
        format.json { render json: @claim_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/claim_companies/1
  # DELETE /admin/claim_companies/1.json
  def destroy
    respond_to do |format|
      if @claim_company.update(is_active: false)
        format.html { redirect_to [:admin, @claim_company.claim], notice: 'Company was successfully removed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to current_user, notice: 'Company could not be removed.' }
        format.json { render json: @claim_company.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_claim
    @claim = Claim.find(params[:claim_id])
  end
  
  def set_claim_company
    @claim_company = ClaimCompany.find(params[:id])
  end

  def claim_company_params
    params.fetch(:claim_company, {}).permit(:is_employer, :is_workplace, :is_active, :claim_id, :company_id)
  end
  
  def company_params
    params.fetch(:claim_company, {}).require(:company_attributes).permit(:name, :contact, :abn, :email, :phone)
  end
end
