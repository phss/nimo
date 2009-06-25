require File.dirname(__FILE__) + '/../../spec_helper'

class StubWithVelocity < Nimo::GameObject
  include Nimo::Behavior::WithVelocity
end

describe Nimo::Behavior::WithVelocity do
  
  it "should move according to speed and velocity" do
    obj = StubWithVelocity.new(:speed => 10, :velocity => Object.from_hash(:x => 0.2, :y => 0.5))
    
    obj.move
    
    obj.x.should == 2
    obj.y.should == 5 
  end
  
end
