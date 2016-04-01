require_relative '../test_helper'

class ClaimTest < ActiveSupport::TestCase
  test "Claim::presentable_attributes" do
    skip "best way to test a whitelist function?"
  end
  
  test "#display_affidavit?" do
    # turn on when fixtures complete.
    # assert claims(:basic).display_affidavit?
    refute claims(:over_min).display_affidavit?
  end
  
  test "#enable_affidavit?" do
    skip "insufficient fixture coverage"
  end
  
  # three tests: complete wage evidence; complete time evidence w/o complete wage evidence;
  # incomplete wage and time evidence.
  test "#actual_pay" do
    skip "insufficient fixture coverage"
  end
  
  test "ownership" do
    assert_equal claims(:basic).owner, claims(:basic).user
    assert_equal Claim.new.owner, nil
    
    assert_includes claims(:basic).owners, claims(:basic).user
    assert_empty Claim.new.owners
  end
  
  test "#stolen_wages" do
    assert claims(:basic).stolen_wages > 0
    assert claims(:over_min).stolen_wages.zero?
  end
  
  test "employment duration" do
    employment_days_int = claims(:basic).employment_ended_on - claims(:basic).employment_began_on
    
    assert_equal claims(:basic).send(:weeks_worked), employment_days_int / 7.0
    assert_instance_of Set, claims(:basic).days
  end
  
  test "proper award names" do
    assert_equal claims(:basic).proper_award, "Horticulture Award 2010"
    assert_equal claims(:over_min).proper_award, "Poultry Processing Award 2010"
  end
  
  test "award minimums" do
    assert_equal claims(:basic).award_minimum, 21.61 #horticulture
    assert_equal claims(:over_min).award_minimum, 22.34 #poultry
  end
  
  test "#document_coverage should be a set" do
    assert_instance_of Set, claims(:basic).document_coverage
  end
  
  test "#coverage_gaps" do
    employment_days_arr = Array(claims(:basic).employment_began_on..claims(:basic).employment_ended_on)
    
    assert_includes claims(:over_min).coverage_gaps, employment_days_arr
    assert_empty claims(:basic).coverage_gaps
  end
  
  test "#coverage_complete?" do
    refute claims(:over_min).coverage_complete?
    assert claims(:basic).coverage_complete?
  end
end
