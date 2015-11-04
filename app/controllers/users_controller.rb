class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

<<<<<<< HEAD
=======
    # The user's address
    @user.build_address(user_address_params)

    # The user's claim
    @user.build_claim(user_claim_params)

    # The user's claim's address
    @user.claim.build_address(user_claim_address_params)

    # The user's claim's employer
    @user.claim.build_employer(user_claim_employer_params)

    # The user's claim's employer's address
    @user.claim.employer.build_address(user_claim_employer_address_params)

>>>>>>> 165f7838e4b001f6b224e95ba3d40b382436c82f
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:family_name, :given_name, :email, :phone, :country, :postal_code, :province, :town, :street_address, :secondary_street_address, :preferred_language, :follow_up_detail)
    end
<<<<<<< HEAD
=======

    def user_address_params
      address_params(params.require(:user))
    end

    def user_claim_params
      params.require(:user).require(:claim_attributes).permit(:award, :total_hours, :hourly_pay, :employment_began_on, :employment_ended_on, :employment_type)
    end

    def user_claim_address_params
      address_params(params.require(:user).require(:claim_attributes))
    end

    def user_claim_employer_params
      params.require(:user).require(:claim_attributes).require(:employer_attributes).permit(:name, :email, :phone, :abn)
    end

    def user_claim_employer_address_params
      address_params(params.require(:user).require(:claim_attributes).require(:employer_attributes))
    end

    def address_params(params_subset)
      params_subset.require(:address_attributes).permit(:street_address, :secondary_street_address, :town, :province, :postal_code, :country)
    end
>>>>>>> 165f7838e4b001f6b224e95ba3d40b382436c82f
end
