require_relative '../test_helper'

class DocumentTest < ActiveSupport::TestCase
  def setup
    @doc = documents(:statement)
  end
  
  test "midpoint between start and end dates" do
    assert_equal Date.new(2015, 6, 30), @doc.coverage_midpoint
  end
  
  test "days of coverage" do
    assert_instance_of Set, @doc.days
    assert_equal 91, @doc.days.size
  end
  
  test "financial years" do
    assert_equal 2014, @doc.fy
    assert_equal 2014, @doc.coverage_start_date.fy
    assert_equal 2015, @doc.coverage_end_date.fy
    assert_equal Date.new(2015, 6, 30), @doc.coverage_start_date.end_of_fy
    
    assert_equal 2014, documents(:even_fy_split).fy
  end
end
