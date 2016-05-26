require "test_helper"

class CanAddCompanyTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  def setup
    user = users(:owner)
    claim = claims(:basic)
    profile = profiles(:basic)
    user.claim = claim
    user.profile = profile

    login_as user, scope: :user
    visit new_claim_claim_company_path(claim_id: claim.id)
  end

  class ManualEntry < CanAddCompanyTest
    def setup
      super

      click_link "Enter it yourself"
      fill_in "Name of business", with: "Acme Corp"
      fill_in "Name of contact person", with: "Elmer Fudd"
      fill_in "Contact phone", with: "05-555-5555"
    end

    test "add a workplace" do
      check "This company is my workplace"
      click_button "Save company details"

      assert_content "Company (Workplace)"
      assert_content "Name: Acme Corp"
      refute_content "errors"
    end

    test "add an employer" do
      check "This company is my employer"
      click_button "Save company details"

      assert_content "Company (Employer)"
      assert_content "Name: Acme Corp"
      refute_content "errors"
    end

    test "add both" do
      check "This company is my workplace"
      check "This company is my employer"
      click_button "Save company details"

      assert_content "Company (Workplace & Employer)"
      assert_content "Name: Acme Corp"
      refute_content "errors"
    end
  end
end