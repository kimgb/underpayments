require "test_helper"

class CanAddProfileTest < Capybara::Rails::TestCase
  include ActiveJob::TestHelper
  include Warden::Test::Helpers
  Warden.test_mode!
  
  # Feedback without logging in
  test "send feedback without logging in" do
    visit root_path
    click_link "Send feedback?"
    set_email "admin@nuw.org.au"
    set_message "Hello"
    
    perform_enqueued_jobs do
      click_button "Send feedback"
      
      refute ActionMailer::Base.deliveries.empty?
      
      delivered_email = ActionMailer::Base.deliveries.last
      assert_includes delivered_email.to, "kbuckley@nuw.org.au"
    end
    
    assert_current_path "/"
    assert_content "Feedback is on its way!"
  end
  
  test "send feedback while logged in" do
    login_as users(:claimant)
    visit root_path
    click_link "Send feedback?"
    set_message "Hello"
    
    perform_enqueued_jobs do
      click_button "Send feedback"
      
      refute ActionMailer::Base.deliveries.empty?
      
      delivered_email = ActionMailer::Base.deliveries.last
      assert_includes delivered_email.to, "kbuckley@nuw.org.au"
    end
    
    assert_includes Capybara.current_path, "/users/#{users(:claimant).id}"
    assert_content "Feedback is on its way!"
  end
  
  private
  def set_email(value)
    fill_in "Your email", with: value
  end
  
  def set_message(value)
    fill_in "Your message", with: value
  end
end
