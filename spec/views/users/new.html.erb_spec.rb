require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :family_name => "MyString",
      :given_name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :country => "MyString",
      :postal_code => "MyString",
      :province => "MyString",
      :town => "MyString",
      :street_address => "MyString",
      :secondary_street_address => "MyString",
      :preferred_language => "MyString"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_family_name[name=?]", "user[family_name]"

      assert_select "input#user_given_name[name=?]", "user[given_name]"

      assert_select "input#user_email[name=?]", "user[email]"

      assert_select "input#user_phone[name=?]", "user[phone]"

      assert_select "input#user_country[name=?]", "user[country]"

      assert_select "input#user_postal_code[name=?]", "user[postal_code]"

      assert_select "input#user_province[name=?]", "user[province]"

      assert_select "input#user_town[name=?]", "user[town]"

      assert_select "input#user_street_address[name=?]", "user[street_address]"

      assert_select "input#user_secondary_street_address[name=?]", "user[secondary_street_address]"

      assert_select "input#user_preferred_language[name=?]", "user[preferred_language]"
    end
  end
end
