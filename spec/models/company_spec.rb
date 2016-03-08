require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "#owners" do
    context "an orphaned company" do
      it "should return an empty array" do
        company = build_stubbed(:company)

        expect(company.owners).to eq []
      end
    end
    
    context "an associated company" do
      it "should include at least one user" do
        claim_company = create(:claim_company)
        company = claim_company.company
        
        expect(company.owners).to include(a_kind_of(User))
      end
    end
  end
end
