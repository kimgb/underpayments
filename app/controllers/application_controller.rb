class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  # before_action :root_for_signed_in_user
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_users_url : user_url(resource)
    # stored_location_for(resource) || root_url
  end

  def forbidden!
    render file: "public/403.html", status: :forbidden, layout: false
  end
  
  protected
  def authenticate_inviter!
    authorise_admin!
  end

  private
  def set_locale
    available_locales = I18n.available_locales.map(&:to_s)
    supported_locale = if params[:locale].is_a?(Array)
      # get the earliest supported locale
      params[:locale].find { |locale| available_locales.include?(locale) }
    else
      params[:locale] if available_locales.include?(params[:locale])
    end
    
    # set locale, fall back to default if no supported locale requested.
    I18n.locale = supported_locale || I18n.default_locale
  end

  # def root_for_signed_in_user
  #   redirect_to current_user if (request.path == root_path && current_user)
  # end

  def root_path_without_locale
    root_path.gsub(/en$|en-AU$|vi$|zh$|zh-TW$/, "")
  end

  def authorise_admin!
    if current_user && current_user.admin?
      current_user
    else
      forbidden!
    end
  end

  # def authorise_owner!(resource)
  #   forbidden unless resource.owner && resource.owner == current_user
  # end
end
