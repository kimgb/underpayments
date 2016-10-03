require "test_helper"

class Admin::LetterTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    @claim = claims(:underpaid_w_multi_docs)

    admin = users(:admin)
    login_as admin, scope: :user
  end
  
  test "generate and show letter" do
    visit new_admin_claim_letter_path(@claim, skin: "fair-food")
    
    select "Elmer Fudd", from: "Addressee"
    fill_in "Email contact (e.g. assist@nuw.org.au)", with: "nuwassist@nuw.org.au"
    select "General Branch - Sam Roberts", from: "Signature"

    click_button '' # Glyphicon button. Neat trick?

    assert_content "Dear Elmer Fudd"
    assert_content "member Jane Doe, who formerly worked for Acme Ltd"
    assert_content "at nuwassist@nuw.org.au. Kind regards Sam Roberts"
  end
  
  test "edit and show letter" do
    letter = letters(:standard)
    visit edit_admin_letter_path(letter, skin: "fair-food")
    
    select "Victoria Branch - Gary Maas", from: "Signature"
    click_button ''
    
    assert_content "Kind regards Gary Maas"
  end
  
  test "delete letter" do
    letter = letters(:standard)
    visit admin_letter_path(letter, skin: "fair-food")
    
    find(".glyphicon-trash").click
    
    assert_content "Letter removed."
  end
end
