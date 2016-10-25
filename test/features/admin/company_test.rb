require "test_helper"

class Admin::CompanyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    user = users(:admin)

    login_as user, scope: :user
    visit admin_root_path
    click_link "Administrate"
    click_link "Companies"
  end
  
  test "create a company" do
    click_link "Create new company", match: :first
    
    fill_in "Name", with: "Acme Co. Ltd"
    fill_in "Contact", with: "Elmer Fudd"
    fill_in "Phone", with: "055555555"
    fill_in "Email", with: "efudd@acme.com"
    fill_in "ABN", with: "55555555550"

    click_button "Save company details"

    assert_content "Company 'Acme Co. Ltd' created!"
  end
  
  test "edit a company" do
    click_link "Edit", match: :first
    
    fill_in "Name", with: "Acme Pty Ltd"
    
    click_button "Save company details"
    
    assert_content "Company 'Acme Pty Ltd' updated!"
  end
  
  test "enter a bad ABN" do
    click_link "Create new company", match: :first
    
    fill_in "Name", with: "Acme Co. Ltd"
    fill_in "Contact", with: "Elmer Fudd"
    fill_in "Phone", with: "055555555"
    fill_in "Email", with: "efudd@acme.com"
    fill_in "ABN", with: "55555555555"
    
    click_button "Save company details"
    
    assert_content "ABN must be valid"
  end
end
