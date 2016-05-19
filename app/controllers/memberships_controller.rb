class MembershipsController < ApplicationController
  # GET /membership?email=some@guy.com&external_id=NA000000&mobile=0455555555
  def show
    @user = User.find_by_email(membership_params[:email])
    @person = NUW::Person.get(membership_params)
    
    render :show, layout: false
  end
  
  private
  def membership_params
    params.permit(:external_id, :email, :mobile)
  end
end
