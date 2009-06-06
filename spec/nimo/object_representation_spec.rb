require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::ObjectRepresentation do
  
  it "should execute registered update event" do
    was_updated = false
    representation = Nimo::ObjectRepresentation.new(nil, nil)
    representation.always { was_updated = true }
    
    representation.update
    
    was_updated.should be_true
  end
  
  it "should not execute key event when key was not pressed" do
    was_updated = false
    mock_window = mock("game window")
    mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).and_return(false)
    representation = Nimo::ObjectRepresentation.new(mock_window, nil)
    representation.when_key(Gosu::Button::KbLeft) { was_updated = true }
    
    representation.update
    
    was_updated.should be_false
  end
  
  it "should execute key event when key is pressed" do
    was_updated = false
    mock_window = mock("game window")
    mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).and_return(true)
    representation = Nimo::ObjectRepresentation.new(mock_window, nil)
    representation.when_key(Gosu::Button::KbLeft) { was_updated = true }
    
    representation.update
    
    was_updated.should be_true
  end
end