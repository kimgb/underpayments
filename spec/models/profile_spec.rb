require 'rails_helper'

RSpec.describe Profile, type: :model do
  before(:all) do
    @profile = build_stubbed(:profile)
  end

  describe "#full_name" do
    it "should print given and family names joined with a space" do
      expect(@profile.full_name).to eq "Tess Casey"
    end
  end

  describe "#owner" do
    it "should return the associated user" do
      expect(@profile.owner).to be @profile.user
    end
  end
end