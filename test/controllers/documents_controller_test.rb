require_relative "../test_helper"

class DocumentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  class Owner < DocumentsControllerTest
    def setup
      sign_in users(:owner)
    end

    test "get show with signed in owner" do
      get :show, id: documents(:statement)
      assert_response :success
      assert_not_nil assigns(:document)
    end

    test "get new with signed in user" do
      get :new, claim_id: claims(:underpaid).id
      assert_response :success
      assert_not_nil assigns(:document)
    end
  end

  class Admin < DocumentsControllerTest
    def setup
      sign_in users(:admin)
    end

    test "get show with signed in admin" do
      get :show, id: documents(:statement)
      assert_response :success
      assert_not_nil assigns(:document)
    end
  end

  class NonOwner < DocumentsControllerTest
    def setup
      sign_in users(:non_owner)
    end

    test "get show with signed in non-owner" do
      get :show, id: documents(:statement)
      assert_response :forbidden
    end
  end

  class GuestUser < DocumentsControllerTest
    test "get new with guest user" do
      get :new, claim_id: claims(:underpaid).id
      assert_response :redirect
    end

    test "get show with guest user" do
      get :show, id: documents(:statement)
      assert_response :redirect
    end
  end
end
