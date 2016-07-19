require "test_helper"

class Admin::LetterTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    admin = users(:admin)
    claim = claims(:underpaid_w_multi_docs)

    login_as admin, scope: :user
    visit new_admin_claim_letter_path(claim, skin: "fair-food")
  end
  
  test "generate letter" do
    select "Elmer Fudd", from: "Addressee"
    fill_in "Email contact (e.g. assist@nuw.org.au)", with: "nuwassist@nuw.org.au"
    select "General Branch - Sam Roberts", from: "Signature"

    click_button ''

    assert_content "Dear Elmer Fudd"
    assert_content "member Jane Doe, who formerly worked at Acme Ltd"
    assert_content "at nuwassist@nuw.org.au. Kind regards Sam Roberts"
  end
end
