require_relative "../../test_helper"

class FinancialYearsTest < MiniTest::Test
  def setup
    @dec_16_end = Date.new(2016, 12, 31)
    @mar_16_end = Date.new(2016, 3, 31)
    @start_of_2016_fy = Date.new(2016, 7, 1)
    @start_of_2015_fy = Date.new(2015, 7, 1)
    @end_of_2016_fy = Date.new(2017, 6, 30)
    @end_of_2015_fy = Date.new(2016, 6, 30)
  end
  
  def test_fy_returns_correctly
    assert_equal 2016, @dec_16_end.fy
    assert_equal 2015, @mar_16_end.fy
  end
  
  def test_beginning_of_fy
    assert_equal @start_of_2016_fy, @dec_16_end.beginning_of_fy
    assert_equal @start_of_2015_fy, @mar_16_end.beginning_of_fy
    assert_equal @start_of_2015_fy, Date.new(2016).beginning_of_fy
  end
  
  def test_end_of_fy
    assert_equal @end_of_2016_fy, @dec_16_end.end_of_fy
    assert_equal @end_of_2015_fy, @mar_16_end.end_of_fy
    assert_equal @end_of_2015_fy, Date.new(2016).end_of_fy
  end
end
