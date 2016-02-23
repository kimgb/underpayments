require 'rails_helper'

RSpec.describe Claim, type: :model do
  before(:all) do
    @claim = build_stubbed(:claim)
    @employment_period = Array(@claim.employment_began_on..@claim.employment_ended_on)
  end

  describe "#owner" do
    context "when there is a user association" do
      it "should return the associated user" do
        @claim = build_stubbed(:claim_with_user)

        expect(@claim.owner).to be @claim.user
      end
    end

    context "when there is no user association" do
      it "should return nil" do
        expect(@claim.owner).to be_nil
      end
    end
  end

  describe "#lost_wages" do
    context "when rate of pay is under the legal minimum" do
      it "should return a positive number" do
        @claim.hourly_pay = 21.60

        expect(@claim.lost_wages).to be > 0
      end
    end

    context "when rate of pay is at or above the legal minimum" do
      it "should return zero" do
        @claim.hourly_pay = 21.61

        expect(@claim.lost_wages).to eq(0)
      end
    end
  end

  describe "#weeks_worked" do
    it "should return a long floating point" do
      expect(@claim.weeks_worked(@claim.employment_began_on, @claim.employment_ended_on)).to eq(30.571428571428573)
    end
  end

  describe "#award_minimum" do
    it "should return a rate" do
      expect(@claim.award_minimum).to eq(21.61)
    end
  end

  describe "#proper_award" do
    it "should return the proper award name" do
      expect(@claim.proper_award).to eq("Horticulture Award 2010")
    end
  end

  describe "#days" do
    it "should return a set" do
      expect(@claim.days).to be_instance_of(Set)
    end
  end

  describe "#document_coverage" do
    it "should return a set" do
      expect(@claim.document_coverage).to be_instance_of(Set)
    end
  end

  describe "#coverage_gaps" do
    context "without any documents" do
      it "should return the employment period within an array" do
        expect(@claim.coverage_gaps).to contain_exactly(@employment_period)
      end
    end

    context "with documents" do
      it "should return an array of arrays of dates" do
        @document = create(:document)
        @claim = @document.claim
        @gaps = [Array(@claim.employment_began_on...@document.coverage_start_date),
          Array(@document.coverage_end_date.next_day..@claim.employment_ended_on)]

        expect(@claim.coverage_gaps).to match_array(@gaps)
      end
    end
  end

  describe "#coverage_complete?" do
    context "an incomplete claim" do
      it "should return false" do
        document = create(:document)
        claim = document.claim

        expect(claim.coverage_complete?).to be false
      end
    end

    context "a complete claim" do
      it "should return true" do
        document = create(:document, coverage_start_date: Date.new(2015, 1, 1), coverage_end_date: Date.new(2016, 12, 31))
        claim = document.claim

        expect(claim.coverage_complete?).to be true
      end
    end
  end

  describe "#ready_to_submit?" do
    context "when claim is ready" do
      pending "spec likely to change"
    end

    context "when claim isn't ready" do
      pending "spec likely to change"
    end
  end
end
