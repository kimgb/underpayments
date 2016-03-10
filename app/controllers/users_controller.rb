class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorise_owner!, only: [:show, :edit, :update]

  before_action :profile_missing?, except: [:new, :create]

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    redirect_to current_user if signed_in?
    
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.claim = Claim.find(session[:claim_id]) if session[:claim_id].present?

    respond_to do |format|
      if @user.save
        sign_in(@user)
        session[:claim_id] &&= nil

        format.html { redirect_to new_profile_path, notice: 'Account created, now please enter your details.' }
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
        format.html { redirect_to @user, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Lock down an action to logged in admin, or user who is also the owner
  def authorise_owner!
    forbidden! unless current_user && current_user.owns?(@user)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :password, :admin)
  end

  def profile_missing?
    redirect_to new_profile_path, notice: "You haven't created a profile yet. Please enter your details to proceed." unless current_user.profile.present?
  end
end
