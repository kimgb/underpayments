class Admin::AwardsController < Admin::BaseController
  before_action :set_award, only: [:show, :edit, :update, :destroy]
  
  # GET /admin/awards
  # GET /admin/awards.json
  def index
    @awards = Award.all
  end
  
  # GET /admin/awards/1
  def show
  end
  
  # GET /admin/awards/new
  def new
    @award = Award.new
  end
  
  # POST /admin/awards
  def create
    @award = Award.new(award_params)
    
    respond_to do |format|
      if @award.save
        format.html { redirect_to [:admin, @award], notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/awards/1/edit
  def edit
  end
  
  # PATCH/PUT /admin/awards/1
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to [:admin, @award], notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/awards/1
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to admin_awards_url, notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  def set_award
    @award = Award.friendly.find(params[:id])
  end
  
  def award_params
    params.require(:award).permit(:name, :short_name, :default_minimum).tap do |whitelisted|
      whitelisted[:min_permanent_rates] = params[:award][:min_permanent_rates]
      whitelisted[:min_casual_rates] = params[:award][:min_casual_rates]
    end
  end
end
