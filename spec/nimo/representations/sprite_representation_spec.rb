require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::SpriteRepresentation do
  
  before(:each) do
    @mock_window = mock("game window")
    mock_loader = mock("resource loader")
    @tiles = [mock("sprite tile 1"), mock("sprite tile 2"), mock("sprite tile 3"), mock("sprite tile 4")]
    
    @mock_window.should_receive(:resource_loader).and_return(mock_loader)
    mock_loader.should_receive(:load_image_tiles).and_return(@tiles)
    
	  obj = Nimo::GameObject.new(:x => 0, :y => 0, :width => 20, :height => 20, :current_state => :state_one)
    @sprite = Nimo::SpriteRepresentation.new(@mock_window, obj, {}).
      with_animation(:state_one, [0, 1]).
      with_animation(:state_two, [2, 3], :loop => false)
    @sprite.load
  end
  
  it "should draw animation based on game object's current state" do
    @tiles[0].should_receive(:draw).with(0, 0, 0)
    @sprite.draw    
  end
  
  it "should draw the same frame when draw called before frame timeout" do
    @tiles[0].should_receive(:draw).twice.with(0, 0, 0)
    
    2.times { @sprite.draw }
  end
  
  it "should cycle to the next frame of animation after the frame timeout" do
    @tiles[0].should_receive(:draw).with(0, 0, 0)
    @tiles[1].should_receive(:draw).with(0, 0, 0)
    
    2.times { @sprite.draw; sleep 0.2 }
  end
  
  it "should cycle to beginning if it loops animation (by default it should loop)" do
    @tiles[0].should_receive(:draw).twice.with(0, 0, 0)
    @tiles[1].should_receive(:draw).with(0, 0, 0)
    
    3.times { @sprite.draw; sleep 0.2 }
  end
  
  it "should change animation when changing state" do
    @tiles[0].should_receive(:draw).with(0, 0, 0)
    @tiles[2].should_receive(:draw).with(0, 0, 0)
    
    @sprite.draw
    @sprite.change_to(:state_two)
    @sprite.draw
  end
  
  it "should not change animation when game object changes to a state with no animation" do
    @tiles[0].should_receive(:draw).twice.with(0, 0, 0)
    
    @sprite.draw
    @sprite.change_to(:state_none)
    @sprite.draw
  end
  
  it "should keep drawing last frame animation do not loop" do
    @tiles[2].should_receive(:draw).with(0, 0, 0)
    @tiles[3].should_receive(:draw).twice.with(0, 0, 0)
    
    @sprite.change_to(:state_two)
    3.times { @sprite.draw; sleep 0.2 }
  end
end
