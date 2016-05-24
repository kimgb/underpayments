require_relative '../test_helper'

class DocumentTest < ActiveSupport::TestCase
  test "midpoint between start and end dates" do
    doc = documents(:statement)
    
    assert_equal Date.new(2015, 9, 30), doc.coverage_midpoint
  end
end
