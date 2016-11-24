require_relative '../test_helper'

class ClaimTest < ActiveSupport::TestCase
  test "Claim::presentable_attributes" do
    assert_includes Claim.presentable_attributes, "lost_wages"
    refute_includes Claim.presentable_attributes, "id"
  end

  test "#display_affidavit?" do
    # turn on when fixtures complete.
    # assert claims(:underpaid).display_affidavit?
    refute claims(:proper).display_affidavit?
    assert claims(:no_payslips).display_affidavit?
  end

  test "#enable_affidavit?" do
    # depends on full suite of associated fixtures for at least one claim
    assert claims(:no_payslips).enable_affidavit?
  end

  # three test cases:
  #   complete wage evidence;
  #   complete time evidence w/o complete wage evidence;
  #   incomplete wage and time evidence.
  test "#actual_pay" do
    assert claims(:underpaid_w_multi_docs).actual_pay > 0
    assert claims(:underpaid_w_time_docs).actual_pay > 0
    assert claims(:no_payslips).actual_pay > 0
  end

  test "ownership" do
    claim = claims(:underpaid_w_multi_docs)

    assert_equal claim.owner, claim.user
    assert_equal nil, Claim.new.owner
    assert_includes claim.owners, claim.user
    assert_empty Claim.new.owners
  end

  test "#stolen_wages" do
    assert claims(:underpaid).stolen_wages > 0
    assert claims(:underpaid_w_multi_docs).stolen_wages > 0
    assert claims(:proper).stolen_wages.zero?
  end

  test "wages from evidence should only consider wage documents" do
    wfe = claims(:underpaid_w_multi_docs).send(:wages_from_evidence)

    assert_equal "3000.0", wfe.to_s
  end

  test "employment duration" do
    b_under = claims(:underpaid)
    employment_days_int = b_under.days.size

    assert_equal b_under.send(:weeks_worked), employment_days_int / 7.0
    assert_instance_of Set, b_under.days
  end

  test "award minimums" do
    assert_equal 21.61, claims(:underpaid).award_minimum #horticulture, NES casual
    assert_equal 22.34, claims(:poultry_underpaid).award_minimum #poultry casual

    # TODO test a claim beginning 1 Jan 2010
  end

  test "coverage gaps" do
    under, proper = claims(:underpaid), claims(:proper)
    employment_days_arr = [Array(under.employment_began_on..under.employment_ended_on)]

    assert_instance_of Set, under.document_coverage
    assert_equal employment_days_arr, proper.coverage_gaps
    refute proper.coverage_complete?
    assert_empty under.coverage_gaps
    assert under.coverage_complete?
  end

  test "coverage overlaps" do
    assert claims(:overlapping_docs).coverage_overlaps?
  end

  test "time estimation" do
    b_under = claims(:underpaid)
    ebo = b_under.employment_began_on
    year_1_weeks = b_under.send(:weeks_worked, ebo, ebo.end_of_fy)
    year_1_hours = year_1_weeks * b_under.weekly_hours

    assert_equal year_1_hours, b_under.send(:estimated_hours_worked_by_year).values[0]
  end
  
  test "workplace and employer" do
    comp_claim = claims(:underpaid_w_multi_docs)
    incomp_claim = claims(:underpaid)
    
    assert_equal "Acme Ltd", comp_claim.workplace_name
    assert_equal "Acme Ltd", comp_claim.employer_name
    
    assert_nil incomp_claim.workplace_name
    assert_nil incomp_claim.employer_name
  end
end
