class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  before_action :extract_locale_from_accept_language_header
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
  # def set_locale
  #   available_locales = I18n.available_locales.map(&:to_s)
  #   supported_locale = if params[:locale].is_a?(Array)
  #     # get the earliest supported locale
  #     params[:locale].find { |locale| available_locales.include?(locale) }
  #   else
  #     params[:locale] if available_locales.include?(params[:locale])
  #   end
  #   
  #   # set locale, fall back to default if no supported locale requested.
  #   I18n.locale = supported_locale || I18n.default_locale
  # end
  
  # locale precedence: params -> user prefs -> browser -> default
  def set_locale
    supported_locales = I18n.available_locales.map(&:to_s)
    
    I18n.locale = provided_locales.find(&supported_locales.method(:include?))
  end
  
  # finder = supported_locales.method(:include?)
  # 
  # I18n.locale = params_locales.find(&finder) ||
  #   user_locale.find(&finder) ||
  #   language_header_locales.find(&finder) ||
  #   I18n.default_locale
  
  def provided_locales
    [*params_locales, *user_locale, *language_header_locales, *I18n.default_locale].uniq
  end
  
  def params_locales
    [*params[:locale]]
  end
  
  def user_locale
    [*(current_user && current_user.preferred_language)]
  end
  
  def language_header_locales
    langs = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/([\-a-zA-Z]{2,5})(?:;q=(1|0?\.[0-9]{1,3}))?/).map do |pair|
      lang, q = pair
      [lang, (q || '1').to_f]
    end
    
    # sort by q value, map languages and reverse
    langs.sort_by(&:last).map(&:first).reverse
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
  
  def extract_locale_from_accept_language_header
    puts request.env['HTTP_ACCEPT_LANGUAGE'] #.scan(/^[a-z]{2}/).first
  end

  # def authorise_owner!(resource)
  #   forbidden unless resource.owner && resource.owner == current_user
  # end
end
