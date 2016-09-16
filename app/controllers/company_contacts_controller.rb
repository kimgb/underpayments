class CompanyContactsController < ApplicationController
  before_action :set_company_contact, except: [:new, :create]
  before_action :set_company, only: [:new, :create]
  
  # GET /companies/1/company_contacts/new
  def new
    @contact = CompanyContact.new
  end
  
  # POST companies/1/company_contacts
  def create
    @contact = @companies.contacts.build(company_contact_params)
    
    respond_to do |format|
      if @contact.save
        format.json { render :show, status: :ok, location: @company }
        format.html { redirect_to @company, notice: "Contact added." }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end
  
  # GET /company_contacts/1/edit
  def edit
  end
  
  # PATCH/PUT /company_contacts/1
  def update
    respond_to do |format|
      if @contact.update(company_contact_params)
        format.json { render :show, status: :ok, location: @contact.company }
        format.html { redirect_to @company, notice: "Contact updated." }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end
  
  # DELETE /company_contacts/1
  def destroy
    respond_to do |format|
      if @contact.destroy
        format.json { head :no_content }
        format.html { redirect_to @contact.company, notice: "Contact deleted." }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.html { redirect_to @contact.company, notice: "We were unable to delete this contact." } #??
      end
    end
  end
  
  private
  def set_company_contact
    @contact = CompanyContact.find(params[:id])
  end
  
  def set_company
    @company = Company.find(params[:company_id])
  end
  
  def company_contact_params
    params.require(:company_contact).permit(:name, :title, :phones, :emails, :company)
  end
end
