class CompanyAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:new, :create]
  before_action :set_company_address, only: [:show, :edit, :update]
  before_action :set_address, only: [:show, :edit, :update]
  before_action :authorise_owner!, only: [:edit, :update]

  # GET /company_address/1
  def show
  end

  # GET /companies/1/company_address/new
  def new
    @company_address = @company.build_company_address
    @address = @company_address.build_address
  end

  # POST /companies/1/company_address
  # POST /companies/1/company_address.json
  def create
    @company_address = @company.build_company_address(company_address_params)
    @company_address.build_address(address_params) if address_params.any?

    respond_to do |format|
      if @company_address.save
        format.html { redirect_to current_user, notice: 'Company address created.' }
        format.json { render :show, status: :created, location: current_user }
      else
        format.html { render :new }
        format.json { render json: @company_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /company_address/edit
  def edit
  end

  # PATCH/PUT /company_address
  # PATCH/PUT /company_address.json
  def update
    respond_to do |format|
      if @company_address.update(company_address_params) && @address.update(address_params)
        format.html { redirect_to current_user, notice: 'Details successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @company_address.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Lock down an action to logged in admin, or user who is also the owner
  def authorise_owner!
    forbidden! unless current_user && current_user.owns?(@company_address)
  end
  
  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_company_address
    @company_address = current_user.company_address
  end
  
  def set_address
    @address = @company_address.address || @company_address.build_address
  end

  def company_address_params
    params.require(:company_address).permit(
      :is_active, address_attributes: [
        :street_address, :town, :province, :postal_code, :country
      ]
    )
  end
  
  def address_params
    company_address_params[:address_attributes]
  end
end
