require File.dirname(__FILE__) + '/../spec_helper'

class TestScreen < Nimo::Screen
  attr_reader :obj_representations
  
  def representations
    add(StubRepresentation.for("some string", :param => "blah"))
    add(AnotherStubRepresentation.for("another string"))
    add(Nimo::ObjectRepresentation.for("nimo object"))
    add(SomeModule::ModuleObjectRepresentation.for("object in a module"))
  end
end

class StubRepresentation < Nimo::ObjectRepresentation
  attr_reader :param
  def initialize(game_window, game_object, params)
    super(game_window, game_object)
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
    screen = TestScreen.new(nil)
    
    stub = screen.obj_representations.find { |r| r.is_a? StubRepresentation }
    stub.should_not == nil
    stub.param.should == "blah"
    
    [AnotherStubRepresentation, Nimo::ObjectRepresentation, SomeModule::ModuleObjectRepresentation].each do |obj_class|
      screen.obj_representations.find { |r| r.is_a? obj_class }.should_not == nil
    end
  end
  
  it "should forward updates and draws to representations" do
    mock_representation = mock("representation")
    
    mock_representation.should_receive(:game_window=).with("game window")
    screen = TestScreen.new("game window")
    screen.add(mock_representation)
    
    mock_representation.should_receive(:update)
    screen.update
    
    mock_representation.should_receive(:draw)
    screen.draw
  end
  
  it "should change screen" do
    mock_window = mock("window")
    mock_window.should_receive(:go_to).with("Screen")
    
    TestScreen.new(mock_window).go_to("Screen")
  end
  
end