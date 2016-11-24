source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 4.2.5'
gem 'rails-observers'
gem 'i18n' # I18n - we need to support, e.g., Mandarin, Vietnamese
gem 'globalize', '~> 5.0.0' # some things in the database need to be translated, too
gem 'puma' # Use Puma as the web server
gem 'pg' # Use postgresql as the database for Active Record
gem 'pg_search' # full text search on postgresql with pg_search
gem 'figaro' # Figaro for environment variables
gem 'pry'

gem 'devise',           '~> 3.5.2' # Devise for login/auth, plus invitable module
gem 'devise_invitable', '~> 1.5.2'
gem 'devise-i18n'

gem 'mailgun_rails' # Mailgun for transactional email
gem 'sucker_punch' # Suckerpunch as the ActiveJob queue adapter
gem 'exception_notification' # Notify me about exceptions via email/Slack
gem 'slack-notifier'

gem 'friendly_id', '~> 5.1' # Friendly_ID for nice slugs (semantically versioned)

gem 'haml-rails', '~> 0.9' # markup
gem 'redcarpet' # as our Markdown renderer in the Haml :markdown filter
gem 'tilt', '~> 2.0.2'
gem 'sass-rails', '~> 5.0', require: 'tilt/sass'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'uglifier', '>= 1.3.0' # compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'select2-rails' # Select2 for search to local API endpoints.

gem 'carrierwave', '~> 0.11.2' # CarrierWave for file uploads (evidence upload)
gem 'fog' # CarrierWave needs this to use Amazon S3
gem 'mini_magick' # MiniMagick for image manipulation (avoid serving up multi-MB images)

gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

# Note, secret token must be set via `bundle config gem.fury.io <secret-token>`
source "https://gem.fury.io/kimgb/" do
  gem 'nuw-api', '~> 0.1'
end

group :development do
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry-rails' # `rails console` will open pry instead of irb

  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',   require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  
  gem 'guard', :require => false
  gem 'guard-minitest', :require => false
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard', :require => false
end

group :test do
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-reporters'
  gem 'minitest-rails-capybara'
  gem 'connection_pool'
  gem 'poltergeist'
  gem 'mocha'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
end
