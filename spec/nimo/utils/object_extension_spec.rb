require File.dirname(__FILE__) + '/../../spec_helper'

describe Object do
  
  it "should create object from hash" do
    obj = Object.from_hash(:a => 1, :b => 2)
    
    obj.a.should == 1
    obj.b.should == 2
  end
  
  it "should set values in the object from hash" do
    obj = Object.from_hash(:a => 1, :b => 2)
    obj.a = 3
    obj.b = 4
    
    obj.a.should == 3
    obj.b.should == 4
  end
  
end