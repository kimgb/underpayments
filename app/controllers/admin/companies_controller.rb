class Admin::CompaniesController < Admin::BaseController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  
  def index
    @companies = Company.all
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    @company.update_attributes(company_params)
    redirect_to admin_company_path(@company), notice: "Updated."
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
