class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_skin, :set_locale, :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options(options={})
    @skin.present? ? { skin: @skin.slug }.merge(options) : options
  end

  def after_sign_in_path_for(user)
    user.admin? ? admin_claims_url(skin: user.group) : user_url(user, skin: user.group)
  end

  def forbidden!
    render file: "public/403.html", status: :forbidden, layout: false
  end

  def not_found!
    render file: "public/404.html", status: :not_found, layout: false
  end

  protected
  def authenticate_inviter!
    authorise_admin!
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite).concat [:group_id]
  end

  private
  def set_skin
    search_slug = (params[:skin] || "").match(Regexp.new(Group.all.map(&:slug).join("|"))).to_s
    @skin = ltd_user_signed_in? ? Group.find(current_user.group_id) : Group.friendly.find(search_slug)
  rescue ActiveRecord::RecordNotFound => err
    unless search_slug.blank?
      flash[:notice] = "Couldn't find a campaign with name '#{params[:skin]}', reverting to default."
    end
  ensure #always runs
    @skin ||= Group.first
  end

  # locale precedence: params -> user prefs -> browser -> default
  def set_locale
    supported_locales = I18n.available_locales.map(&:to_s)

    I18n.locale = provided_locales.find(&supported_locales.method(:include?))

    session[:locale] = I18n.locale
  end

  # combines locales from various sources in order of priority. set union `|`
  # removes duplicates - keeps only the highest priority occurrence of any given
  # locale. Array#compact removes nils.
  def provided_locales
    (params_locales | user_locale | session_locale | language_header_locales | [I18n.default_locale]).compact
  end

  def params_locales
    [*params[:locale]]
  end

  def session_locale
    [*session[:locale]]
  end

  def user_locale
    [*(current_user && current_user.preferred_language)]
  end

  def language_header_locales
    # Scary regex is not that scary! On an example header string (mine):
    # "en-AU,en-US;q=0.7,en;q=0.3".match(rx) => [["en-AU", nil], ["en-US", "0.7"], ["en", "0.3"]]
    rx = /([A-Za-z]{2}(?:-[A-Za-z]{2})?)(?:;q=(1|0?\.[0-9]{1,3}))?/
    langs = request.env['HTTP_ACCEPT_LANGUAGE'].to_s.scan(rx).map do |lang, q|
      [lang, (q || '1').to_f]
    end

    # sort by q value, map languages and reverse
    langs.sort_by(&:last).map(&:first).reverse
  end

  def reset_session_locale
    session.delete :locale
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
  
  def admin_signed_in?
    user_signed_in? && current_user.admin?
  end
  
  def ltd_user_signed_in?
    user_signed_in? && !current_user.admin?
  end
end
