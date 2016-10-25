require "test_helper"

class Admin::GroupTest < Capybara::Rails::TestCase
  include CapybaraHelpers
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.current_driver = :poltergeist
    user = users(:admin)

    login_as user, scope: :user
    visit admin_root_path
    click_link "Administrate"
    click_link "Campaigns"
  end
  # 
  # test "create a campaign" do
  #   click_link "New Campaign"
  #   
  #   find("#select2-group_supergroup_id-container").click
  #   all(".select2-search__field").first
  #   
  #   binding.pry
  #   
  #   fill_in "Name", with: "Acme Co. Ltd"
  #   fill_in "Contact", with: "Elmer Fudd"
  #   fill_in "Phone", with: "055555555"
  #   fill_in "Email", with: "efudd@acme.com"
  #   fill_in "ABN", with: "55555555550"
  # 
  #   click_button "Save campaign details"
  # 
  #   assert_content "Company 'Acme Co. Ltd' created!"
  # end
  
  def teardown
    Capybara.use_default_driver
  end
  
  # test "edit a campaign" do
  #   click_link "Edit", match: :first
  #   
  #   fill_in "Name", with: "Acme Pty Ltd"
  #   
  #   click_button "Save campaign details"
  #   
  #   assert_content "Company 'Acme Pty Ltd' updated!"
  # end
  # 
  # test "enter a bad ABN" do
  #   click_link "Create new campaign", match: :first
  #   
  #   fill_in "Name", with: "Acme Co. Ltd"
  #   fill_in "Contact", with: "Elmer Fudd"
  #   fill_in "Phone", with: "055555555"
  #   fill_in "Email", with: "efudd@acme.com"
  #   fill_in "ABN", with: "55555555555"
  #   
  #   click_button "Save campaign details"
  #   
  #   assert_content "ABN must be valid"
  # end
end
