require_relative '../test_helper'

class UpdateClaimTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  
  test "instantiates" do
    assert UpdateClaim.new(user: users(:admin), claim: claims(:underpaid_w_multi_docs))
  end
  
  test "success and failure" do
    uc1 = UpdateClaim.new(user: users(:admin), claim: claims(:underpaid))
    uc2 = UpdateClaim.new(user: users(:non_owner), claim: claims(:underpaid))
    params = { claim: { comment: "I'm progressing this claim", stage: claim_stages(:success) } }
    
    res1 = uc1.call(params)
    res2 = uc2.call(params)
    
    assert res1.success?
    assert_equal res1.message, "Claim updated."
    refute res2.success?
    assert_equal res2.message, "User lacks authority to make this update."
  end
  
  test "both emails enqueued on stage update" do
    assert_enqueued_jobs 2 do
      uc = UpdateClaim.new(user: users(:admin), claim: claims(:underpaid))
      params = { claim: { claim_stage_id: claim_stages(:success).id, comment: "New stage!" }, notify_claimant: true }
      
      res = uc.call(params)
    end
  end
  
  test "emails delivered to expected recipients" do
    perform_enqueued_jobs do
      uc = UpdateClaim.new(user: users(:admin), claim: claims(:underpaid))
      params = { claim: { claim_stage_id: claim_stages(:success).id, comment: "New stage!" }, notify_claimant: true }
    end
  end
end
