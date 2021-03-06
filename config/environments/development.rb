Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  # NOTE: true for financial_years.rb
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Config mailer to use Mailgun
  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
    api_key: Figaro.env.mailgun_api_key,
    domain: Figaro.env.mailgun_domain
  }
  # Don't care about delivery errors in development
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { host: Figaro.env.app_host, port: Figaro.env.app_port }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Save on line prints (gets rid of can't log to ::1 warnings)
  config.web_console.whiny_requests = false

  # Exception notifier - post to Slack and email
  # config.middleware.use ExceptionNotification::Rack,
  #   slack: {
  #     webhook_url: "https://hooks.slack.com/services/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",
  #     channel: "#exceptions"
  #   },
  #   email: {
  #     sender: %{"notifier" <notifier@sandboxdf8c7f5edee24435b6baf2b87ed843d4.mailgun.org>},
  #     exception_recipients: %w[kbuckley@nuw.org.au]
  #   }
end
