source 'https://rubygems.org'

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.5'
# Use Puma as the web server
gem 'puma'
# Use postgresql as the database for Active Record
gem 'pg'
# + full text search on postgresql with pg_search
gem 'pg_search'
# Figaro for environment variables
gem 'figaro'
# Devise for login/auth, plus invitable module
gem 'devise',           '~> 3.5.2'
gem 'devise_invitable', '~> 1.5.2'
# Mailgun for transactional email
gem 'mailgun_rails'
# Suckerpunch as the ActiveJob queue adapter
gem 'sucker_punch'
# Notify me about exceptions in the production environment, via email/Slack
gem 'exception_notification'
gem 'slack-notifier'
# Pry for a nicer interpreter
gem 'pry'
# Haml for markup, plus Redcarpet as our Markdown renderer for content
gem 'haml-rails', '~> 0.9'
gem 'redcarpet'
gem 'tilt', '~> 2.0.2'

# I18n - we need to support, e.g., Mandarin, Vietnamese
gem 'i18n'
gem 'devise-i18n'

# Friendly_ID for nice slugs; semantically versioned - minor point changes are non-breaking.
gem 'friendly_id', '~> 5.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', require: 'tilt/sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'

# CarrierWave for file uploads (evidence upload)
gem 'carrierwave'
# MiniMagick for image manipulation (avoid serving up multi-MB images)
gem 'mini_magick'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Google V8, allows Less to operate, allows variables in Bootstrap CSS
# gem 'therubyracer'
# gem 'less-rails'
# gem 'twitter-bootstrap-rails'

# SASS instead of LESS for Bootstrap
gem 'bootstrap-sass', '~> 3.3.6'

# Select2 for search to local API endpoints.
gem 'select2-rails'

# Note, secret token must be set via `bundle config gem.fury.io <secret-token>`
source "https://gem.fury.io/kimgb/" do
  gem 'nuw-api', '~> 0.1'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # `rails console` will open pry instead of irb
  gem 'pry-rails'

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
  # gem 'launchy'
  # gem 'mocha'
  # gem 'shoulda-context'
  # gem 'shoulda-matchers'
  # gem 'test_after_commit'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'
end
