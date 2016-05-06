class Admin::SupergroupsController < Admin::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /admin/supergroups
  # GET /admin/supergroups.json
  def index
    @supergroups = Supergroup.all
  end

  # GET /admin/supergroups/1
  # GET /admin/supergroups/1.json
  def show
  end

  # GET /admin/supergroups/new
  def new
    @supergroup = Supergroup.new
  end

  # GET /admin/supergroups/1/edit
  def edit
  end

  # POST /admin/supergroups
  # POST /admin/supergroups.json
  def create
    @supergroup = Supergroup.new(supergroup_params)

    respond_to do |format|
      if @supergroup.save
        format.html { redirect_to @supergroup, notice: 'Organisation was successfully created.' }
        format.json { render :show, status: :created, location: @supergroup }
      else
        format.html { render :new }
        format.json { render json: @supergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/supergroups/1
  # PATCH/PUT /admin/supergroups/1.json
  def update
    respond_to do |format|
      if @supergroup.update(supergroup_params)
        format.html { redirect_to @supergroup, notice: 'Organisation was successfully updated.' }
        format.json { render :show, status: :ok, location: @supergroup }
      else
        format.html { render :edit }
        format.json { render json: @supergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/supergroups/1
  # DELETE /admin/supergroups/1.json
  def destroy
    @supergroup.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Organisation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @supergroup = Supergroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supergroup_params
      params.require(:supergroup).permit(:name, :short_name, :www, :description)
    end
end
