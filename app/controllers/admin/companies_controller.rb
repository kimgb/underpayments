class Admin::CompaniesController < Admin::BaseController
  before_action :set_company, only: [:edit, :update, :destroy]
  
  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(company_params)
    
    respond_to do |format|
      if @company.save
        format.html { redirect_to [:admin, @company], notice: "Company '#{@company.name}' created!" }
      else
        format.html { render :new }
      end
    end
  end
  
  def index
    @companies = Company.all
  end
  
  def show
    @company = Company.includes(:claims).find(params[:id])
  end
  
  def edit
  end
  
  def update
    @company.update_attributes(company_params)
    redirect_to [:admin, @company], notice: "Company '#{@company.name}' updated!"
  end
  
  def destroy
    @company.destroy
    redirect_to admin_companies_path
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end
  
  def company_params
    params.require(:company).permit(:name, :contact, :email, :phone, :abn)
  end
end
