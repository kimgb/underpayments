class Admin::AddressesController < Admin::BaseController
  before_action :set_address, except: [:new, :create]
  before_action :set_profile, only: [:new, :create]
  
  # GET /admin/profiles/1/address/new
  def new
    @address = Address.new
  end
  
  # POST /admin/profiles/1/address
  def create
    @address = @profile.build_address(address_params)
    
    respond_to do |format|
      if @profile.save
        format.html { redirect_to admin_claim_path(@profile.user.claim), notice: "Address added." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /addresses/1/edit
  def edit
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to admin_root_path, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
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
      format.html { redirect_to admin_root_path, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.  
  def set_address
    @address = Address.find(params[:id])
  end
  
  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def address_params
    params.require(:address).permit(:street_address, :town, :province, :postal_code, :country)
  end
end
