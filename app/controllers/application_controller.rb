class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :root_for_signed_in_user

  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_url
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def root_for_signed_in_user
    redirect_to current_user if (request.path == root_path_without_locale && current_user)
  end

  def root_path_without_locale
    root_path.gsub(/en$|en-AU$|vi$|zh$|zh-TW$/, "")
  end

  def authorise_admin!
    unless current_user && current_user.admin?
      render file: "public/403.html", status: :forbidden, layout: false
    end
  end
end
