require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::GameObject do
  
  it "should have initial position and dimension values of 0" do
    temp_obj = Nimo::GameObject.new
    
    temp_obj.x.should be_zero
    temp_obj.y.should be_zero
    temp_obj.width.should be_zero
    temp_obj.height.should be_zero
    temp_obj.center.x.should be_zero
    temp_obj.center.y.should be_zero
  end
  
  it "should override position and dimension values" do
    temp_obj = Nimo::GameObject.new(:x => 10, :y => 20, :width => 30, :height => 40)
    
    temp_obj.x.should == 10
    temp_obj.y.should == 20
    temp_obj.width.should == 30
    temp_obj.height.should == 40
    temp_obj.center.x.should == 25
    temp_obj.center.y.should == 40
  end
  
  describe "(setting position and dimension)" do
    
    it "should set object's position" do
      temp_obj = Nimo::GameObject.new
      temp_obj.at(10, 20)
      
      temp_obj.x.should == 10
      temp_obj.y.should == 20
    end
    
    it "should set object's dimension" do
      temp_obj = Nimo::GameObject.new
      temp_obj.dimension(10, 20)
      
      temp_obj.width.should == 10
      temp_obj.height.should == 20
    end
    
    it "should set object's position and dimension through config hash" do
      temp_obj = Nimo::GameObject.new
      temp_obj.configure_with(:x => 10, :y => 20, :width => 30, :height => 40)
      
      temp_obj.x.should == 10
      temp_obj.y.should == 20
      temp_obj.width.should == 30
      temp_obj.height.should == 40
    end
    
  end
  
  describe "(collisions and intersections)" do
    
    def assert_intersection(obj, x, y, width, height)
      obj.x.should == x
      obj.y.should == y
      obj.width.should == width
      obj.height.should == height
    end
    
    it "should not collide when not intersecting an object" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 100, :y => 100, :width => 20, :height => 20)
      
      temp_obj1.collide?(temp_obj2).should be_false
      temp_obj2.collide?(temp_obj1).should be_false
      temp_obj1.intersection(temp_obj2).should be_nil
      temp_obj2.intersection(temp_obj1).should be_nil
    end

    it "should collide with itself" do
      temp_obj = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      
      temp_obj.collide?(temp_obj).should be_true
      assert_intersection(temp_obj.intersection(temp_obj), 10, 10, 20, 20)
    end

    it "should collide when intersecting through the left/right" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 20, :y => 20, :width => 50, :height => 5)
      
      temp_obj1.collide?(temp_obj2).should be_true
      temp_obj2.collide?(temp_obj1).should be_true
      assert_intersection(temp_obj1.intersection(temp_obj2), 20, 20, 10, 5)
      assert_intersection(temp_obj2.intersection(temp_obj1), 20, 20, 10, 5)
    end

    it "should collide when intersecting through the left-top corner/right-bottom corner" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 20, :y => 20, :width => 50, :height => 50)
      
      temp_obj1.collide?(temp_obj2).should be_true
      temp_obj2.collide?(temp_obj1).should be_true
      assert_intersection(temp_obj1.intersection(temp_obj2), 20, 20, 10, 10)
      assert_intersection(temp_obj2.intersection(temp_obj1), 20, 20, 10, 10)
    end

    it "should collide when intersecting through the top/bottom" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 20, :y => 5, :width => 5, :height => 50)
      
      temp_obj1.collide?(temp_obj2).should be_true
      temp_obj2.collide?(temp_obj1).should be_true
      assert_intersection(temp_obj1.intersection(temp_obj2), 20, 10, 5, 20)
      assert_intersection(temp_obj2.intersection(temp_obj1), 20, 10, 5, 20)
    end

    it "should collide when intersecting through the right-top corner/left-bottom corner" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 20, :y => 5, :width => 30, :height => 30)
      
      temp_obj1.collide?(temp_obj2).should be_true
      temp_obj2.collide?(temp_obj1).should be_true
      assert_intersection(temp_obj1.intersection(temp_obj2), 20, 10, 10, 20)
      assert_intersection(temp_obj2.intersection(temp_obj1), 20, 10, 10, 20)
    end 

    it "should collide when an object encompasses the other" do
      temp_obj1 = Nimo::GameObject.new(:x => 10, :y => 10, :width => 20, :height => 20)
      temp_obj2 = Nimo::GameObject.new(:x => 5, :y => 5, :width => 100, :height => 100)
      
      temp_obj1.collide?(temp_obj2).should be_true
      temp_obj2.collide?(temp_obj1).should be_true
      assert_intersection(temp_obj1.intersection(temp_obj2), 10, 10, 20, 20)
      assert_intersection(temp_obj2.intersection(temp_obj1), 10, 10, 20, 20)
    end 
    
  end
  
  describe "(event notification)" do
    
    it "should notify event to registered listener" do
      mock_listener = mock("listener")
      mock_listener.should_receive(:notify).with(:some_event)
      
      obj = Nimo::GameObject.new
      obj.register_listener(:some_event, mock_listener)
      obj.notify(:some_event)
    end
    
    it "should notify multiple listeners" do
      mock_listener1 = mock("listener")
      mock_listener2 = mock("listener")
      mock_listener1.should_receive(:notify).with(:some_event)
      mock_listener2.should_receive(:notify).with(:some_event)
      
      obj = Nimo::GameObject.new
      obj.register_listener(:some_event, mock_listener1)
      obj.register_listener(:some_event, mock_listener2)
      obj.notify(:some_event)
    end
    
    it "should not notify event of different type" do
      mock_listener = mock("listener")
      mock_listener.should_not_receive(:notify).with(:another_event)
      mock_listener.should_not_receive(:notify).with(:some_event)
      
      obj = Nimo::GameObject.new
      obj.register_listener(:some_event, mock_listener)
      obj.notify(:another_event)
    end
    
  end
    
end
