class CompaniesController < ApplicationController
  before_action :authenticate_user!
  
  # GET /companies
  def index
    @companies = params[:term] ? Company.search(params[:term]) : Company.all
    
    respond_to do |format|
      format.json { render json: @companies.to_json(include: [:address]) }
    end
  end
end
