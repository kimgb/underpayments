source 'https://rubygems.org'

ruby "2.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use Puma as the web server
gem 'puma'
# Use postgresql as the database for Active Record
gem 'pg'
# Figaro for environment variables
gem 'figaro'
# Devise for login/auth, plus invitable module
gem 'devise',           '~> 3.5.2'
gem 'devise_invitable', '~> 1.5.2'
# Mailgun for transactional email
gem 'mailgun_rails'
# Pry for a nicer interpreter.
gem 'pry'

# I18n - we need to support, e.g., Mandarin, Vietnamese
gem 'i18n'
gem 'devise-i18n'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
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
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # `rails console` will open pry instead of irb
  gem 'pry-rails'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug'

  # RSpec for unit testing of models
  gem 'rspec-rails'
end

