require "test_helper"

class Admin::SupergroupsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in users(:admin)
  end

  test "index with JSON response" do
    get :index, format: :json
    
    assert_includes @response.body, 'National Union of Workers'
  end
  
  test "search with JSON response" do
    get :index, format: :json, term: "national"
    
    assert_includes @response.body, 'National Union of Workers'
  end
end
