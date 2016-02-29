require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "#owner" do
    it "should return false" do
      company = build_stubbed(:company)

      expect(company.owner).to be false
    end
  end
end
