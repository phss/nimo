require File.dirname(__FILE__) + '/../../spec_helper'

class StubMoveable < Nimo::GameObject
  include Nimo::Behavior::Moveable
end

describe Nimo::Behavior::Moveable do

  describe "(moving)" do |variable|
    it "should not move when speed is zero" do
      obj = StubMoveable.new
      obj.move_left
      
      obj.x.should == 0
      obj.y.should == 0
    end
    
    it "should move left" do
      obj = StubMoveable.new(:speed => 5)
      obj.move_left
      
      obj.x.should == -5
      obj.y.should == 0
    end
    
    it "should move right" do
      obj = StubMoveable.new(:speed => 5)
      obj.move_right
      
      obj.x.should == 5
      obj.y.should == 0
    end
    
    it "should move up" do
      obj = StubMoveable.new(:speed => 5)
      obj.move_up
      
      obj.x.should == 0
      obj.y.should == -5      
    end
    
    it "should move down" do
      obj = StubMoveable.new(:speed => 5)
      obj.move_down
      
      obj.x.should == 0
      obj.y.should == 5
    end
  end
  
  describe "(with boundary)" do
    it "should stop at left boundary" do
      obj = StubMoveable.new(:speed => 5, :boundary => Object.from_hash(:x => -2))
      obj.move_left
      
      obj.x.should == -2
    end
    
    it "should stop at right boundary" do
      obj = StubMoveable.new(:speed => 5, :boundary => Object.from_hash(:x => 0, :width => 2))
      obj.move_right
      
      obj.x.should == 2
    end
    
    it "should stop at upper boundary" do
      obj = StubMoveable.new(:speed => 5, :boundary => Object.from_hash(:y => -2))
      obj.move_up
      
      obj.y.should == -2
    end
    
    it "should stop at bottom boundary" do
      obj = StubMoveable.new(:speed => 5, :boundary => Object.from_hash(:y => 0, :height => 2))
      obj.move_down
      
      obj.y.should == 2
    end
  end

end