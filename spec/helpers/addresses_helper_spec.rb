require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AddressesHelper. For example:
#
# describe AddressesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe AddressesHelper, type: :helper do
  describe "Markdown string of Australian postal format" do
    before(:all) do 
      @address = build(:address)
    end

    context "when there is an address and addressee" do
      it "should build a well-formatted address" do
        expect(markdown_postal_format("Steve", @address)).to eq("Steve  \n833 Bourke St  \nDocklands  \nVIC&emsp;3008")
      end
    end
  end
end
