ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails/capybara"
# Dir[Rails.root.join("test/support/**/*")].each { |f| require f }
Dir[Rails.root.join("test/support/**/*")].each(&method(:require))
require "mocha/mini_test"

# Improved Minitest output (colour and progress bar)
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

# Capybara and poltergeist integration
require "capybara/rails"
require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist

class ActiveSupport::TestCase
  fixtures :all
  
  private
  def write_cache
    Claim.find_each do |claim|
      Rails.cache.write("#{claim.cache_key}/external_id", nil)
    end
    
    member_claim = claims(:search_result_member_claim)
    Rails.cache.write("#{member_claim.cache_key}/external_id", "NV391215")
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

# PgSearch::Document table is empty when test db built from fixtures.
PgSearch::Multisearch.rebuild(Claim)

# See: https://gist.github.com/mperham/3049152
# Commenting as it caused weird Postgres errors, e.g.:
# "WARNING:  there is no transaction in progress" and
# "Message type 0x43 arrived from server while idle"
# ... and I can't remember why I used it in the first place.
# class ActiveRecord::Base
#   mattr_accessor :shared_connection
#   @@shared_connection = nil
# 
#   def self.connection
#     @@shared_connection || ConnectionPool::Wrapper.new(size: 1) { retrieve_connection }
#   end
# end
# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
