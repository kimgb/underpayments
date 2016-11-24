require 'test_helper'

class ClaimSearchTest < ActiveSupport::TestCase
  test "email search" do
    claims = find_claims(keywords: 'kbuckley@nuw.org.au')
    emails = claims.map(&:user_email).uniq
    
    assert emails.count == 1, "Expected claims with only kbuckley@nuw.org.au emails"
    assert emails.first == "kbuckley@nuw.org.au"
  end

  # TODO complex keyword search? @ seems to cause trouble
  test "partial email search" do
    claims = find_claims(keywords: "kbuckley")
    emails = claims.map(&:user_email).uniq
    
    assert emails.count == 1, "Expected claims with only kbuckley@nuw.org.au emails"
    assert emails.first == "kbuckley@nuw.org.au"
  end

  test "profile name keyword search" do
    # mix of preferred name, first name, last name
    claims = find_claims(keywords: "jane Doe")
    emails = claims.map(&:user_email).uniq
    
    assert emails.count == 1, "Expected claims with only kbuckley@nuw.org.au emails"
    assert emails.first == "kbuckley@nuw.org.au"
  
    claims = find_claims(keywords: "janie-poo Doe")
    emails = claims.map(&:user_email).uniq
    
    assert emails.count == 1, "Expected claims with only kbuckley@nuw.org.au emails"
    assert emails.first == "kbuckley@nuw.org.au"
  end

  test "member only search" do
    write_cache
    
    claims = find_claims(include_non_members: false)
    
    assert claims.count == 1, "Expected one claim for members search"
    assert claims.first.user.email == "search_result_member_user@nuw.org.au"
  end

  test "non member only search" do
    write_cache
    
    claims = find_claims(include_members: false)
    emails = claims.map { |c| c.user.try(:email) }
    
    assert !emails.include?('search_result_member_user@nuw.org.au'), "Did not expect member in non members search"
  end

  test "employer keyword search" do
    claims = find_claims(keywords: 'Acme')
    employers = claims.map( &:employer_name ).uniq
    
    assert employers.count == 1, "Expected claims from only one employer"
    assert employers.first == 'Acme Ltd', "Expected only claims from Acme Ltd Employer"
  end

  test "workplace keyword search" do
    # TODO claim with workplace different to employer
    claims = find_claims(keywords: 'Acme')
    workplace = claims.map(&:workplace_name).uniq
    
    assert workplace.count == 1, "Expected claims from only one workplace"
    assert workplace.first == 'Acme Ltd', "Expected only claims from Acme Ltd Workplace"
  end

  test "award stage keyword search" do
    claims = find_claims(keywords: "poultry award")
    awards = claims.map(&:award_name).uniq
    
    assert awards.count == 1, "Expected one claim from only one award"
    assert awards.first == "Poultry Processing Award 2010"
  end
 
  test "claim stage keyword search" do
    claims = find_claims(keywords: "abandoned")
    system_values = claims.map {|c| c.stage.try(:system_name) }.uniq
    
    assert system_values == ['abandoned'], "Expected only abandoned claims, got #{system_values}"
  end

  test "claim stage display name keyword search" do
    claims = find_claims(keywords: "Resolved")
    
    assert claims.size == 1
  end
  
  private
  def find_claims(params)
    ClaimSearch.new({
      user: users(:admin),
      point_person: 'all'
    }.merge(params)).claims
  end
end
