require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = build_stubbed(:user)
    @admin = build_stubbed(:admin)
  end

  describe "#admin?" do
    context "admin users" do
      it "should be admins" do
        expect(@admin.admin?).to be true
      end
    end

    context "non-admin users" do
      it "should not be admins" do
        expect(@user.admin?).to be false
      end
    end
  end

  describe "#owner" do
    it "should be self" do
      expect(@user.owner).to be @user
      expect(@admin.owner).to be @admin
    end
  end

  describe "#owns?" do
    context "admin users" do
      it "should be true" do
        expect(@admin.owns?(nil)).to be true
      end
    end

    context "non-admin users" do
      it "should own themselves" do
        expect(@user.owns?(@user)).to be true
      end
    end
  end

  describe "#ready_to_submit?" do
    pending "depending on final spec of Claim#ready_to_submit?"
  end
end
