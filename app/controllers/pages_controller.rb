class PagesController < ApplicationController
  def show
    #@page = Page.friendly.find(params[:page])
    @page = params[:page]
    # render inline: @page.content.html_safe, layout: :default
  end
end
