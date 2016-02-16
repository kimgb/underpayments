class PagesController < ApplicationController
  def show
    if current_user && params[:page] == :start
      redirect_to show_user_path(current_user)
    else
      @page = params[:page]
      @user = User.find(params[:user])

      render :show, layout: (params[:layout] == "print" ? false : :default)
    end
    #@page = Page.friendly.find(params[:page])
    # render inline: @page.content.html_safe, layout: :default
  end

  def test_exception_notification
    raise "Testing, 1 2 3"
  end
end
