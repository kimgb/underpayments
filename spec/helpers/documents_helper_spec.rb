require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DocumentsHelper. For example:
#
# describe DocumentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe DocumentsHelper, type: :helper do
  describe "date from request parameters" do
    context "when there are no request parameters" do
      it "should return today's date" do
        expect(date_from_params(:coverage_start_date)).to eq(Date.today)
      end
    end

    context "when there are request parameters" do
      it "should return a date object" do
        params[:coverage_start_date] = "2016-01-01"
        expect(date_from_params(:coverage_start_date)).to be_instance_of(Date)
      end
    end
  end
end
