require_relative "../../test_helper"

class FinancialYearsTest < MiniTest::Test
  include FinancialYears
  
  def setup
    @dec_16_end = Date.new(2016, 12, 31)
    @mar_16_end = Date.new(2016, 3, 31)
    @start_of_2016_fy = Date.new(2016, 7, 1)
    @start_of_2015_fy = Date.new(2015, 7, 1)
    @end_of_2016_fy = Date.new(2017, 6, 30)
    @end_of_2015_fy = Date.new(2016, 6, 30)
  end
  
  def test_fy_returns_correctly
    assert_equal @dec_16_end.fy, 2016
    assert_equal @mar_16_end.fy, 2015
  end
  
  def test_beginning_of_fy
    assert_equal @dec_16_end.beginning_of_fy, @start_of_2016_fy
    assert_equal @mar_16_end.beginning_of_fy, @start_of_2015_fy
    assert_equal @start_of_2016_fy, @start_of_2016_fy
  end
  
  def test_end_of_fy
    assert_equal @dec_16_end.end_of_fy, @end_of_2016_fy
    assert_equal @mar_16_end.end_of_fy, @end_of_2015_fy
    assert_equal @end_of_2015_fy, @end_of_2015_fy
  end
end
