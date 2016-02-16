require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  describe "GET #index" do
    pending "spec not finalised"
  end

  describe "GET #new" do
    before(:each) do
      @claim = create(:claim)
      @user = build_stubbed(:user)
      sign_in @user

      get :new, claim_id: @claim.id
    end

    it "returns http success" do
      expect(assigns(:document)).to be_a_new(Document)
      expect(response).to have_http_status(:success)
    end
  end
end
