require "test_helper"

class CanAddProfileTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!

  test "add profile and address" do
    login_as users(:owner), scope: :user
    visit new_profile_path

    fill_in 'Family name', with: "Doe"
    fill_in 'Given name(s)', with: "Jane"
    fill_in 'Preferred name', with: "Jane"
    page.find('#profile_date_of_birth_3i').set "1"
    page.find('#profile_date_of_birth_2i').set "January"
    page.find('#profile_date_of_birth_1i').set "1990"
    fill_in 'Phone', with: "0423456789"
    select "Taiwan", from: "Nationality"
    select "English (Australian)", from: "Preferred language"
    select "417 - Working Holiday visa", from: "Australian visa status"
    select "It's not that simple", from: "Gender"

    fill_in 'Address', with: "833 Bourke St"
    fill_in 'Suburb', with: "Docklands"
    fill_in 'State', with: "Victoria"
    fill_in 'Postcode', with: "3008"
    select "Australia", from: "Country"

    click_button 'Submit'

    assert_content page, "Your personal details DONE Your address DONE"
    refute_content page, "errors"
  end
end
