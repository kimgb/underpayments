require "test_helper"

class Admin::ClaimTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    user = users(:admin)
    @claim = claims(:underpaid_w_multi_docs)

    login_as user, scope: :user

    # PgSearch::Document table is empty when test db built from fixtures.
    PgSearch::Multisearch.rebuild(Claim)
    write_cache
  end
  
  test "update the claim stage" do
    visit admin_claim_path(@claim, skin: Group.first)
  
    select "Resolved - successful", from: "Set new stage"
    fill_in "Detail", with: "Finalised terms of settlement with company's lawyers."
    
    find(".glyphicon-ok[type=submit]").click
    # click_button("", class: "glyphicon-ok", match: :first)
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

  test "list claims" do
    visit admin_claims_path(skin: Group.first)
    # Expected number of rows maybe
  end

  test "search claims by keyword" do
    visit admin_claims_path(skin: Group.first)
    select "any", from: "Point person"
    fill_in "Keywords", with: "search_result_member_user@nuw.org.au"
    click_button "Search"

    assert_content "Search Result Member"
    assert_no_content "Search Result Non Member"
  end

  test "search claims by member status" do
    visit admin_claims_path(skin: Group.first)

    # TODO Check default setting (both members and non-members ticked)
    
    select "any", from: "Point person"
    check "Members"
    check "Non members"
    click_button "Search"
    assert_content "Search Result Member"
    assert_content "Search Result Non Member"

    check "Members"
    uncheck "Non members"
    click_button "Search"
    assert_content "Search Result Member"
    assert_no_content "Search Result Non Member"
    
    uncheck "Members"
    check "Non members"
    click_button "Search"
    assert_no_content "Search Result Member"
    assert_content "Search Result Non Member"
  end

  test "search claims by point person" do
    visit admin_claims_path(skin: Group.first)

    # check default setting (point person is set to current user)
    assert has_select?('claim_search_point_person', selected: 'Admin User'), "Expected default point person to be Admin User"

    # test changing point person 
    select("Other Admin User", from: "Point person")
    click_button "Search"
    
    assert_no_content "Search Result Member"
    assert_content "Search Result Non Member"
  end

  test "search claims by no point person set on claim" do
    visit admin_claims_path(skin: Group.first)
    select("no assigned point person", from: "Point person")
    click_button "Search"
    assert_no_content "Search Result Member"
    assert_no_content "Search Result Non Member"
    assert_content "Janie-poo Doe"
  end

  test "search claims by point person search field blank" do
    visit admin_claims_path(skin: Group.first)
    select("any", from: "Point person")
    click_button "Search"
    assert_content "Search Result Member"
    assert_content "Search Result Non Member"
    assert_content "Janie-poo Doe"
  end
end
