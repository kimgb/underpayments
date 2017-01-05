class Admin::ClaimStagesController < Admin::BaseController
  before_action :set_claim_stage, except: [:index, :new, :create]
  
  # GET /admin/claim_stages
  def index
    @claim_stages = ClaimStage.all
  end
  
  # GET /admin/claim_stages/new
  def new
    @claim_stage = ClaimStage.new
  end
  
  # POST /admin/claim_stages
  def create
    @claim_stage = ClaimStage.new(claim_stage_params)
    
    respond_to do |format|
      if @claim_stage.save
        format.html { redirect_to admin_claim_stages_path, notice: "Stage created!" }
        format.json { render :show, status: :created, location: @claim_stage }
      else
        format.html { render :new }
        format.json { render json: @claim_stage.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/claim_stages/1/edit
  def edit
  end
  
  # PATCH/PUT /admin/claim_stages/1
  def update
    respond_to do |format|
      if @claim_stage.update(claim_stage_params)
        format.html { redirect_to admin_claim_stages_path, notice: "Stage updated!" }
        format.json { render :show, status: :created, location: @claim_stage }
      else
        format.html { render :edit }
        format.json { render json: @claim_stage.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/claim_stages/1
  def destroy
    @claim_stage.destroy
    respond_to do |format|
      format.html { redirect_to admin_claim_stages_path, notice: 'Stage was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::InvalidForeignKey => e
    respond_to do |format|
      format.html { redirect_to admin_claim_stages_path, notice: 'Unable to delete stage as it has claims assigned.' }
      format.json 
    end
  end
  
  private
  def set_claim_stage
    @claim_stage = ClaimStage.find(params[:id])
  end
  
  def claim_stage_params
    params.require(:claim_stage).permit(:category, :system_name, :display_name, :notification_text)
  end
end
