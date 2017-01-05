class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :set_address, only: [:show, :edit, :update]
  before_action :authorise_owner!, only: [:edit, :update]

  # GET /profile
  def show
    redirect_to new_profile_path, notice: "Profile missing - please add one below!" if @profile.nil?
  end

  # GET /profile/new
  def new
    # if current_user.profile
    #   redirect_to current_user, notice: 'This account already has a profile.'
    # else
      @profile = Profile.new
      @address = @profile.build_address
    # end
  end

  # POST /profile
  # POST /profile.json
  def create
    @profile = current_user.build_profile(profile_params)
    if address_params.any?
      @profile.build_address(address_params)
    end

    respond_to do |format|
      if @profile.save
        format.html { redirect_to current_user, notice: 'Profile created.' }
        format.json { render :show, status: :created, location: current_user }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /profile/edit
  def edit
  end

  # PATCH/PUT /profile
  # PATCH/PUT /profile.json
  def update
    respond_to do |format|
      if @profile.update_attributes(profile_params)
        format.html { redirect_to current_user, notice: 'Details successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile
  # DELETE /profile.json
  def destroy
    respond_to do |format|
      if @profile.update(address: nil)
        format.html { redirect_to current_user, notice: 'Address removed.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Lock down an action to logged in admin, or user who is also the owner
  def authorise_owner!
    forbidden! unless current_user && current_user.owns?(@profile)
  end

  def set_profile
    @profile = current_user.profile
  end

  def set_address
    @address = @profile.address || @profile.build_address
  end

  def profile_params
    params.require(:profile).permit(:date_of_birth, :family_name, :given_name,
      :preferred_name, :phone, :preferred_language, :nationality, :visa,
      :gender, :address_id, :media_volunteer, address_attributes: 
      [:street_address, :town, :province, :postal_code, :country])
  end

  def address_params
    params.fetch(:profile).fetch(:address_attributes).permit(:street_address,
      :town, :province, :postal_code, :country)
  end
end
