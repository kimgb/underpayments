class Admin::PreviewsController < Admin::BaseController
  # GET /admin/groups/1
  # GET /admin/groups/1.json
  def show
    @preview = preview_params
    
    render :show, layout: false
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def preview_params
      params.permit(:primary_colour, :secondary_colour, :base_colour, :bg_colour)
    end
end
