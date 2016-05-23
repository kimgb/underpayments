require "test_helper"

class CanUploadDocumentsTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  def setup
    user = users(:owner)
    claim = claims(:basic)
    profile = profiles(:basic)
    user.claim = claim
    user.profile = profile

    login_as user, scope: :user
    visit new_claim_document_path(claim_id: claim.id)

    check "This document is evidence of wages paid to me"
    check "This document is evidence of hours I have worked"
    fill_in "How much does this document indicate you were paid?", with: "2916"
    fill_in "How many hours does this document indicate that you worked?", with: "173"
    page.find("#document_coverage_start_date_3i").set "1"
    page.find("#document_coverage_start_date_2i").set "April"
    page.find("#document_coverage_start_date_1i").set "2015"
    page.find("#document_coverage_start_date_3i").set "30"
    page.find("#document_coverage_start_date_2i").set "April"
    page.find("#document_coverage_start_date_1i").set "2015"
  end

  test "upload a .pdf" do
    attach_file("Upload an image or document", Rails.root + "test/fixtures/blank.pdf")
    click_button "Add document"

    assert_content "Document was successfully uploaded."
    refute_content "errors"
  end

  test "upload a .doc" do
    attach_file("Upload an image or document", Rails.root + "test/fixtures/blank.doc")
    click_button "Add document"

    assert_content "Document was successfully uploaded."
    refute_content "errors"
  end
end
