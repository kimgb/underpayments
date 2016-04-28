class MembershipsController < ApplicationController
  # GET /membership?email=some@guy.com&external_id=NA000000&mobile=0455555555
  def show
    @person = NUW::Person.get(membership_params)
    
    render :show, layout: false
  end
  
  private
  def membership_params
    params.permit(:external_id, :email, :mobile)
  end
end
