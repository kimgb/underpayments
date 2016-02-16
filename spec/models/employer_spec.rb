require 'rails_helper'

RSpec.describe Employer, type: :model do
  describe "#owner" do
    it "should return false" do
      employer = build_stubbed(:employer)

      expect(employer.owner).to be false
    end
  end
end
