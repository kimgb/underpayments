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
      params.permit(:links, :headings, :body_text, :body_bg, :btn_text, :btn_bg, :nav_text, :nav_bg, :intro)
    end
end
