class WorkplacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workplace, only: [:show, :edit, :update, :destroy]
  before_action :set_claim, only: [:new, :create]
  before_action :authorise_admin!, except: [:new, :create, :edit, :update]

  # GET /workplaces/1
  def show
    redirect_to current_user
  end

  # GET /claims/1/workplaces/new
  def new
    @workplace = Workplace.new
  end

  # GET /workplaces/1/edit
  def edit
  end

  # POST /claims/1/workplaces
  # POST /claims/1/workplaces.json
  def create
     @workplace = @claim.build_workplace(workplace_params)

    respond_to do |format|
      if @workplace.save && @claim.save
        format.html { redirect_to @claim.user, notice: 'Workplace was successfully created.' }
        format.json { render :show, status: :created, location: @claim.user }
      else
        format.html { render :new }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workplaces/1
  # PATCH/PUT /workplaces/1.json
  def update
    respond_to do |format|
      if @workplace.update(workplace_params)
        format.html { redirect_to current_user, notice: 'Workplace was successfully updated.' }
        format.json { render :show, status: :ok, location: @workplace.claim.user }
      else
        format.html { render :edit }
        format.json { render json: @workplace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workplaces/1
  # DELETE /workplaces/1.json
  def destroy
    @workplace.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Workplace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_workplace
    @workplace = Workplace.find(params[:id])
  end

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def workplace_params
    params.require(:workplace).permit(:name, :contact, :abn, :phone, :email)
  end

  def authorise_owner!
    forbidden unless @workplace.users.include?(current_user)
  end
end
