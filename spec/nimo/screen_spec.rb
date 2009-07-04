require File.dirname(__FILE__) + '/../spec_helper'

class TestScreen < Nimo::Screen
  attr_reader :representations
  
  def load
    add(StubRepresentation, :for => "some string", :with => {:param => "blah"})
    add(AnotherStubRepresentation, :for => "another string")
    add(Nimo::ObjectRepresentation, :for => "nimo object")
    add(SomeModule::ModuleObjectRepresentation, :for => "object in a module")
  end
end

class StubRepresentation < Nimo::ObjectRepresentation
  attr_reader :param

  def load(resources, params)
    @param = params[:param]
  end
  
end

class AnotherStubRepresentation < Nimo::ObjectRepresentation
end

module SomeModule
  class ModuleObjectRepresentation < Nimo::ObjectRepresentation
  end
end

describe Nimo::Screen do
  
  it "should initialize representations" do
    screen = TestScreen.new(nil, nil)
    
    stub = screen.representations.find { |r| r.is_a? StubRepresentation }
    stub.should_not be_nil
    stub.param.should == "blah"
    
    [AnotherStubRepresentation, Nimo::ObjectRepresentation, SomeModule::ModuleObjectRepresentation].each do |obj_class|
      screen.representations.find { |r| r.is_a? obj_class }.should_not be_nil
    end
  end
  
  it "should change screen" do
    mock_window = mock("window")
    mock_window.should_receive(:go_to).with("Screen")
    
    TestScreen.new(mock_window, nil).go_to("Screen")
  end
  
  it "should register and execute event" do
    event_called = false
    
    screen = TestScreen.new(nil, nil)
    screen.when(:on_enter) { event_called = true }
    
    event_called.should == false
    screen.notify(:on_enter)
    event_called.should == true
  end
  
  describe "(loading representations)" do
    before(:each) do
      @representation_class = mock("representation class")
      @representation = mock("representation")
      @representation_class.should_receive(:new).and_return(@representation)
      @screen = Nimo::Screen.new(nil, nil)
    end
    
    it "should load representation using the :with params" do
      with_params = { :blah => "something" }
      @representation.should_receive(:load).with(nil, with_params)
      @screen.add(@representation_class, {:with => with_params})
    end
    
    it "should forward updates and draws to representations" do
      @representation.should_receive(:load).with(nil, {})
      @screen.add(@representation_class, {})

      @representation.should_receive(:update)
      @screen.update

      @representation.should_receive(:draw)
      @screen.draw
    end  
  end
  
end