require "test_helper"

class Admin::ClaimTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    user = users(:admin)
    claim = claims(:underpaid_w_multi_docs)

    login_as user, scope: :user
    visit admin_claims_path(claim)
  end
  
  test "update the claim stage" do
    select "Resolved - successful", from: "Set new stage"
    fill_in "Detail", with: "Finalised terms of settlement with company's lawyers."
    
    click_button "Update claim"
    # click_link "Create new company", match: :first
    # 
    # fill_in "Name", with: "Acme Co. Ltd"
    # fill_in "Phone", with: "055555555"
    # fill_in "Email", with: "efudd@acme.com"
    # fill_in "ABN", with: "55555555550"
    # 
    # click_button "Save company details"

    # assert_content "Company 'Acme Co. Ltd' created!"
  end
end
