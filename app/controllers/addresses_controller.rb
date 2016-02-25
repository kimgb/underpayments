class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]
  before_action :set_addressable, only: [:new, :create]

  # GET /addressable/:addressable_id/addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
     @address = @addressable.build_address(address_params)

    respond_to do |format|
      if @address.save
        format.html { redirect_to current_user, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @addressable }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to current_user, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address.addressable }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to @address.addressable, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def find_addressable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  def set_addressable
    @addressable = find_addressable
  end

  def set_address
    @address = Address.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def address_params
    params.require(:address).permit(:street_address, :secondary_street_address, :town, :province, :postal_code, :country)
  end
end
