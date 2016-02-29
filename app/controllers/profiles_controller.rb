class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update]
  before_action :authorise_owner!, only: [:edit, :update]

  # GET /profile
  def show
  end

  # GET /profile/new
  def new
    if current_user.profile
      redirect_to current_user, notice: 'This account already has a profile.'
    else
      @profile = Profile.new
      @profile.build_address
    end
  end

  # POST /profile
  # POST /profile.json
  def create
    @profile = current_user.build_profile(profile_params)
    @profile.build_address(address_params) if address_params.any?

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
    @profile.build_address(address_params) if address_params.any?
    
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to current_user, notice: 'Details successfully updated.' }
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

  def profile_params
    params.require(:profile).permit(
      :date_of_birth, :family_name, :given_name, :preferred_name, 
      :phone, :preferred_language, :nationality, :visa, :gender, 
      address_attributes: [
        :street_address, :town, :province, :postal_code, :country
      ]
    )
  end
  
  def address_params
    profile_params[:address_attributes]
  end
end
