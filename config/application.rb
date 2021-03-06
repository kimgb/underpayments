require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Underpaid
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake time:zones:all" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Melbourne'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :"en-AU"
    config.i18n.available_locales = [:en, :"en-AU", :zh, :"zh-TW", :vi, :ko]
    config.i18n.fallbacks = {
      :"en-AU" => :en,
      :"zh-TW" => :zh,
    }

    config.active_record.observers = :claim_observer, :document_observer, :user_observer

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    # Since we're using PostgreSQL's HStore, the schema dump may need to be in SQL, not Ruby
    # config.active_record.schema_format = :sql

    # Set the application secret key through Figaro
    config.secret_key_base = Figaro.env.secret_key_base
    
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    # Uncomment to autoload presenter classes.
    # config.autoload_paths += Dir[Rails.root.join('app', 'presenters', '*')]
    config.eager_load_paths += ["#{Rails.root}/lib"]
    
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    
    # Suckerpunch for background tasks
    config.active_job.queue_adapter = :sucker_punch
  end
end
