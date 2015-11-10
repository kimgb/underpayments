class PagesController < ApplicationController
  def show
    @page = Page.friendly.find(params[:page])
  end
end
