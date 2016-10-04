require "test_helper"

class CanAddClaimTest < Capybara::Rails::TestCase
  include DateSelectHelper
  # def teardown
  #   Capybara.default_max_wait_time = 2
  # end
  
  test "can add claim" do
    visit new_claim_path

    select "Storage, e.g. fruit packing", from: "What industry did you work in?"
    page.find("#claim_hours_per_period").set "32"
    page.find("#claim_pay_per_period").set "18"
    # fill_in "How many hours per week did you work?", with: "32"
    # fill_in "How much were you paid per hour?", with: "18"
    employment_began_on(Date.new(2015, 10, 1))
    employment_ended_on(Date.new(2016, 3, 1))
    select "Casual", from: "Were you casual, or permanent?"

    click_button 'Am I underpaid?'

    # Integration tests pose an interesting puzzle: testing i18n content?
    # Just test English - or break the whole application on missing translation.
    assert_content "This means you were underpaid"
  end
  
  test "can add an old claim" do
    visit new_claim_path

    select "Storage, e.g. fruit packing", from: "What industry did you work in?"
    page.find("#claim_hours_per_period").set "32"
    page.find("#claim_pay_per_period").set "15"
    employment_began_on(Date.new(2010, 1, 1))
    employment_ended_on(Date.new(2010, 12, 31))
    select "Permanent", from: "Were you casual, or permanent?"

    click_button 'Am I underpaid?'

    # Integration tests pose an interesting puzzle: testing i18n content?
    # Just test English - or break the whole application on missing translation.
    assert_content "This means you were underpaid"
  end
  
  # test "can submit claim" do
  #   Capybara.default_max_wait_time = 5
  #   
  #   visit claims_path(claims(:underpaid_w_multi_docs))
  #   
  #   click_button "Submit for review"
  #   
  #   assert_content "Your claim has been submitted for review and is now locked"
  # end
  
  private
  def employment_began_on(date)
    fill_date("claim_employment_began_on", date)
  end
  
  def employment_ended_on(date)
    fill_date("claim_employment_ended_on", date)
  end
end
