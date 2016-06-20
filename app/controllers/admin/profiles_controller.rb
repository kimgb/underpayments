class Admin::ProfilesController < Admin::BaseController
  before_action :set_profile

  # GET /profile/edit
  def edit
  end

  # PATCH/PUT /profile
  # PATCH/PUT /profile.json
  def update
    respond_to do |format|
      if @profile.update_attributes(profile_params)
        format.html { redirect_to admin_user_path(@profile.user), notice: 'Details successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:date_of_birth, :family_name, :given_name, 
      :preferred_name, :phone, :preferred_language, :nationality, :visa, 
      :gender, :address_id, address_attributes: [:street_address, 
      :town, :province, :postal_code, :country])
  end
end
