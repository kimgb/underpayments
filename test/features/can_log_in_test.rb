require "test_helper"

class CanLogInTest < Capybara::Rails::TestCase
  test "log in" do
    visit new_user_session_path
    fill_in 'Email', with: "sysadmin@nuw.org.au"
    fill_in 'Password', with: "ch3ng4M1chANGEmePrEtTYplz"
    click_button 'Sign in'

    assert_content page, "Signed in as"
    refute_content page, "Sign in"
  end
end
