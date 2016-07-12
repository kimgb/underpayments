require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase  
  test "join_form_params" do
    owner = users(:owner)
    
    assert owner.join_form_params
  end
end
