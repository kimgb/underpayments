require_relative "../test_helper"

# Something about these tests causes intermittent Postgres issues?
# 
class MembershipsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in users(:owner)
  end
  
  test "get membership status for existing member" do
    NUW::Person.expects(:get).returns(NUW::Person.new(external_id: 'NV391215'))
    claim = claims(:search_result_member_claim)
    
    get :show, claim_id: claim.id, email: users(:search_result_member_user).email
    assert_response :success
    assert_equal assigns(:person).external_id, 'NV391215'
    
    # claim.reload
    # assert claim.external_id == "NV391215", "Expected external_id to be set"
  end
  
  test "get membership status for non member" do
    NUW::Person.expects(:get).returns(nil)
    claim = claims(:search_result_non_member_claim)
    
    get :show, claim_id: claim.id, email: users(:search_result_non_member_user).email
    assert_response :success
    assert_nil assigns(:person)
  
    # claim.reload
    # assert_nil claim.external_id, "Expected claim id to be nil"
  end
  
  test "get JSON membership for existing member" do
    NUW::Person.expects(:get).returns(NUW::Person.new(external_id: 'NV391215'))
    claim = claims(:search_result_member_claim)
    
    get :show, claim_id: claim.id, email: users(:search_result_member_user).email, format: :json
    assert_response :success
    
    body = JSON.parse(response.body)
    assert_equal body["external_id"], "NV391215"
    
    # claim.reload
    # assert claim.external_id == "NV391215", "Expected external_id to be set"
  end
end
