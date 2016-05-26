require_relative '../test_helper'

class ClaimTest < ActiveSupport::TestCase  
  test "Claim::presentable_attributes" do
    skip "best way to test a whitelist function?"
  end
  
  test "#display_affidavit?" do
    # turn on when fixtures complete.
    # assert claims(:basic_underpaid).display_affidavit?
    refute claims(:basic_proper).display_affidavit?
  end
  
  test "#enable_affidavit?" do
    # depends on full suite of associated fixtures for at least one claim
    skip "insufficient fixture coverage"
  end
  
  # three test cases: 
  #   complete wage evidence;
  #   complete time evidence w/o complete wage evidence;
  #   incomplete wage and time evidence.
  test "#actual_pay" do
    skip "insufficient fixture coverage"
  end
  
  test "ownership" do
    assert_equal claims(:basic_underpaid).owner, claims(:basic_underpaid).user
    assert_equal nil, Claim.new.owner
    
    assert_includes claims(:basic_underpaid).owners, claims(:basic_underpaid).user
    assert_empty Claim.new.owners
  end
  
  test "#stolen_wages" do
    assert claims(:basic_underpaid).stolen_wages > 0
    assert claims(:basic_proper).stolen_wages.zero?
  end
  
  test "employment duration" do
    b_under = claims(:basic_underpaid)
    employment_days_int = b_under.days.size
    
    assert_equal b_under.send(:weeks_worked), employment_days_int / 7.0
    assert_instance_of Set, b_under.days
  end
  
  test "proper award names" do
    assert_equal claims(:hort_underpaid).proper_award, "Horticulture Award 2010"
    assert_equal claims(:poultry_underpaid).proper_award, "Poultry Processing Award 2010"
  end
  
  test "award minimums" do
    assert_equal 21.61, claims(:basic_underpaid).award_minimum #horticulture, NES casual
    assert_equal 22.34, claims(:poultry_underpaid).award_minimum #poultry casual
  end
  
  test "#document_coverage should be a set" do
    assert_instance_of Set, claims(:basic_underpaid).document_coverage
  end
  
  test "#coverage_gaps" do
    basic, proper = claims(:basic_underpaid), claims(:basic_proper)
    employment_days_arr = [Array(basic.employment_began_on..basic.employment_ended_on)]
    
    assert_equal employment_days_arr, proper.coverage_gaps
    assert_empty basic.coverage_gaps
  end
  
  test "#coverage_complete?" do
    refute claims(:basic_proper).coverage_complete?
    assert claims(:basic_underpaid).coverage_complete?
  end
  
  test "time estimation" do
    b_under = claims(:basic_underpaid)
    year_1_weeks = b_under.send(:weeks_worked, b_under.employment_began_on, b_under.employment_began_on.end_of_fy)
    year_1_hours = year_1_weeks * b_under.weekly_hours
    
    assert_equal year_1_hours, b_under.send(:estimated_hours_worked_by_year).values[0]
  end
end
