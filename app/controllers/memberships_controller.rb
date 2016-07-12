class MembershipsController < ApplicationController
  # Interface to an external API - no need to set appearance.
  # skip_before_action :set_skin
  
  # GET /membership?email=some@guy.com&external_id=NA000000&mobile=0455555555
  def show
    @user = User.find_by_email(membership_params[:email])
    @person = NUW::Person.get(membership_params)
    
    render :show, layout: false
  end
  
  private
  def membership_params
    params.permit(:external_id, :email, :mobile, :skin)
  end
end
