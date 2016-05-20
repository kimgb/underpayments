require_relative '../test_helper'

class CompanyFacadeTest < ActiveSupport::TestCase
  test "initialize" do
    cf = CompanyFacade.new(Company.new, claims(:basic))
    
    refute cf.persisted?
  end
  
  class Found < CompanyFacadeTest
    def setup 
      @cf = CompanyFacade.find(1)
    end
    
    test "find" do
      assert @cf.persisted?
    end
    
    test "attributes" do
      @cf.attributes = { name: "Acme Pty Ltd", is_employer: false }
      
      refute @cf.is_employer
      assert_equal "Acme Pty Ltd", @cf.name
      refute_equal @cf.name, CompanyFacade.find(1).name #shouldn't be saved
    end
    
    test "update" do
      @cf.update(name: "Acme Pty Ltd", is_employer: false)
      
      refute @cf.is_employer
      assert_equal "Acme Pty Ltd", @cf.name
      assert_equal @cf.name, CompanyFacade.find(1).name #should be saved
    end
  end
end
