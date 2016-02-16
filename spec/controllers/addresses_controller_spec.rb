require 'rails_helper'

# Interaction between let statements and before hooks are a headache

RSpec.describe AddressesController, type: :controller do
  login_user

  let(:valid_attributes) { attributes_for(:address) }
  let(:invalid_attributes) { attributes_for(:invalid_address) }
  let(:user) { create(:user) }

  describe "GET #new" do
    it "assigns a new address as @address" do
      get :new, { user_id: user.to_param }

      expect(response).to have_http_status(:success)
      expect(assigns(:address)).to be_a_new(Address)
    end
  end

  describe "GET #edit" do
    it "assigns the requested address as @address" do
      address = Address.create! valid_attributes
      get :edit, { id: address.to_param }

      expect(response).to have_http_status(:success)
      expect(assigns(:address)).to eq(address)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:each) { 
        @setup = Proc.new { post :create, { user_id: user.to_param, address: valid_attributes } }
        @setup.call
      }

      it "creates a new Address" do
        expect { @setup.call }.to change(Address, :count).by(1)
      end

      it "assigns a newly created address as @address and persists it" do
        expect(assigns(:address)).to be_a(Address)
        expect(assigns(:address)).to be_persisted
      end

      it "redirects to the address owner" do
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      before(:each) { post :create, { user_id: user.to_param, address: invalid_attributes } }

      it "assigns a newly created but unsaved address as @address" do
        expect(assigns(:address)).to be_a_new(Address)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    before(:each) { 
      @address = create(:address)
      @user = create(:user)
      @address.addressable = @user
      @address.save
    }

    after(:each) {
      @address.destroy
      @user.destroy
    }

    context "with valid params" do
      let(:new_attributes) { attributes_for(:updated_address) }

      it "updates the requested address" do
        put :update, { id: @address.to_param, address: new_attributes }
        @address.reload

        expect(@address.street_address).to eq("889 Collins St")
      end

      it "assigns the requested address as @address" do
        put :update, { id: @address.to_param, address: valid_attributes }

        expect(assigns(:address)).to eq(@address)
      end

      it "redirects to the address owner" do
        put :update, { id: @address.to_param, address: valid_attributes }

        expect(response).to redirect_to(@user)
      end
    end

    context "with invalid params" do
      before(:each) { put :update, { id: @address.to_param, address: invalid_attributes } }

      it "assigns the address as @address" do
        expect(assigns(:address)).to eq(@address)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) { 
      @address = create(:address)
      @user = create(:user)
      @address.addressable = @user
      @address.save
    }

    after(:each) {
      @user.destroy
    }

    it "destroys the requested address" do
      expect {
        delete :destroy, { id: @address.to_param }
      }.to change(Address, :count).by(-1)
    end

    it "redirects to the address owner" do
      delete :destroy, { id: @address.to_param }

      expect(response).to redirect_to(@user)
    end
  end
end
