require "test_helper"

class CanAddClaimTest < Capybara::Rails::TestCase
  test "add claim" do
    visit new_claim_path

    select "Storage, e.g. fruit packing", from: "What industry did you work in?"
    page.find("#claim_hours_per_period").set "32"
    page.find("#claim_pay_per_period").set "18"
    # fill_in "How many hours per week did you work?", with: "32"
    # fill_in "How much were you paid per hour?", with: "18"
    page.find("#claim_employment_began_on_3i").set "1"
    page.find("#claim_employment_began_on_2i").set "October"
    page.find("#claim_employment_began_on_1i").set "2015"
    page.find("#claim_employment_ended_on_3i").set "1"
    page.find("#claim_employment_ended_on_2i").set "March"
    page.find("#claim_employment_ended_on_1i").set "2016"
    select "Casual", from: "Were you casual, or permanent?"

    click_button 'Am I underpaid?'

    # Integration tests pose an interesting puzzle: testing i18n content?
    # Just test English - or break the whole application on missing translation.
    assert_content "This means you were underpaid"
  end
end
