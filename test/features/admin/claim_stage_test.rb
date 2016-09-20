require "test_helper"

class Admin::ClaimStageTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    user = users(:admin)
    claim = claims(:underpaid_w_multi_docs)

    login_as user, scope: :user
    visit admin_claim_stages_path(skin: Group.first)
  end
  
  test "index content" do
    assert_content I18n.locale
    assert_content ClaimStage.first.system_name
  end
  
  test "create a new claim stage" do
    click_link "Create new stage"
    
    system_name = "failure"
    display_name = "Abandoned - won't join"
    template_notification = "Closing this claim as user will not join the union."    
    submit
    
    assert_content "Stage created!"
  end
  
  test "edit an existing claim stage" do
    find(".glyphicon-pencil", match: :first).click
    
    template_notification = "A hilarious April Fools prank message!!"
    submit
    
    assert_content "Stage updated!"
  end
  
  test "delete an existing claim stage" do
    find(".glyphicon-trash", match: :first).click
    
    assert_content "Stage was successfully destroyed."
  end
  
  private
  def system_name=(value)
    fill_in "Name used by system", with: value
  end
  
  def display_name=(value)
    fill_in "Name displayed to user", with: value
  end
  
  def template_notification=(value)
    fill_in "Template response", with: value
  end
  
  def submit
    click_button "Submit"
  end
end
