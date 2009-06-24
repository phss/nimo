require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::ObjectRepresentation do
  
  describe "(always actions)" do
    it "should execute registered update event" do
      was_updated = false
      representation = Nimo::ObjectRepresentation.new(nil, nil)
      representation.always { was_updated = true }
    
      representation.update
    
      was_updated.should be_true
    end
  end  
  
  describe "(key actions)" do
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
    
    it "should execute key event multiple times when it is repeatable" do
      num_of_updates = 0
      mock_window = mock("game window")
      mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).twice.and_return(true)
      representation = Nimo::ObjectRepresentation.new(mock_window, nil)
      representation.when_key(Gosu::Button::KbLeft) { num_of_updates += 1 }
    
      2.times { representation.update }
    
      num_of_updates.should == 2
    end
    
    it "should execute non repeatable key event once before clearing the button" do
      num_of_updates = 0
      mock_window = mock("game window")
      mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).twice.and_return(true)
      representation = Nimo::ObjectRepresentation.new(mock_window, nil)
      representation.when_key(Gosu::Button::KbLeft, :repeatable => false) { num_of_updates += 1 }
    
      2.times { representation.update }
    
      num_of_updates.should == 1
    end
  end
  
  describe "(listener actions)" do
    it "should execute action when receive notification" do
      was_updated = false
      mock_object = mock("object")

      representation = Nimo::ObjectRepresentation.new(nil, mock_object)
      mock_object.should_receive(:register_listener).with(:some_event, representation)
      
      representation.listen_to(:some_event) { was_updated = true }
      representation.notify(:some_event)

      was_updated.should be_true
    end
    
    it "should ignore event if not registered" do
      was_updated = false
      mock_object = mock("object")

      representation = Nimo::ObjectRepresentation.new(nil, mock_object)
      mock_object.should_receive(:register_listener).with(:some_event, representation)
      
      representation.listen_to(:some_event) { was_updated = true }
      representation.notify(:another_event)
      
      was_updated.should be_false
    end
  end

	describe "(observer actions)" do
		it "observer called after actions" do
			always_called = false
			key_called = false
	    was_updated = false
      
			mock_window = mock("game window")
			mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).and_return(true)

      representation = Nimo::ObjectRepresentation.new(mock_window, nil)
      representation.always { always_called = true }
      representation.when_key(Gosu::Button::KbLeft) { key_called = true }
			representation.with_observer { |rep, obj| was_updated = true  }

      representation.update
    
      was_updated.should be_true
		end
	end
end
