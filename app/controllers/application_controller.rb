class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  # before_action :root_for_signed_in_user
  
  # def default_url_options(options = {})
  #   { locale: I18n.locale }.merge(options)
  # end

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
  # locale precedence: params -> user prefs -> browser -> default
  def set_locale
    supported_locales = I18n.available_locales.map(&:to_s)

    I18n.locale = provided_locales.find(&supported_locales.method(:include?))
  end
  
  # combines locales from various sources in order of priority. set union `|`
  # removes duplicates - keeps only the highest priority occurrence of any given
  # locale. Array#compact removes nils.
  def provided_locales
    (params_locales | user_locale | language_header_locales | [I18n.default_locale]).compact
  end
  
  # currently, this is stored in the path instead of the query string.
  # this causes problems because locale from param has the highest precedence
  # but it's always set, so no other mode gets a look-in!
  def params_locales
    [*params[:locale]]
  end
  
  def user_locale
    [*(current_user && current_user.preferred_language)]
  end
  
  def language_header_locales
    # Scary regex is not that scary! On an example header string (mine):
    # "en-AU,en-US;q=0.7,en;q=0.3" => [["en-AU", nil], ["en-US", "0.7"], ["en", "0.3"]]
    rx = /([\-a-zA-Z]{2,5})(?:;q=(1|0?\.[0-9]{1,3}))?/
    langs = request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(rx).map do |lang, q|
      [lang, (q || '1').to_f]
    end
    
    # sort by q value, map languages and reverse
    langs.sort_by(&:last).map(&:first).reverse
  end

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
end
