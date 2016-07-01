class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /admin/groups
  # GET /admin/groups.json
  def index
    @groups = Group.all
  end

  # GET /admin/groups/1
  # GET /admin/groups/1.json
  def show
  end

  # GET /admin/groups/new
  def new
    @awards = Award.all
    @group = Group.new
  end

  # GET /admin/groups/1/edit
  def edit
    @awards = Award.all
  end

  # POST /admin/groups
  # POST /admin/groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        # A new group means a new skin - update the routes file
        Rails.application.reload_routes!

        format.html { redirect_to [:admin, @group], notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/groups/1
  # PATCH/PUT /admin/groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to [:admin, @group], notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/groups/1
  # DELETE /admin/groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:supergroup_id, :name, :slug, :intro, time_periods: [], pay_periods: []).tap do |whitelisted|
        whitelisted[:skin] = params[:group][:skin]
        whitelisted[:awards] = params[:group][:awards].reject { |k,v| v.blank? }
      end
    end
end
