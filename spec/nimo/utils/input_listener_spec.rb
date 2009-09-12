require File.dirname(__FILE__) + '/../../spec_helper'

describe "Nimo::InputListener module" do
  
  class SomeActionable
    include Nimo::InputListener
    attr_reader :num_of_updates
    
    def initialize(game_window, acting_upon = self)
      @game_window = game_window
      @num_of_updates = 0
      @acting_upon = acting_upon
    end
    
    def act_upon
      @acting_upon
    end
  end
  
  describe "(key actions)" do
    it "should not execute key event when key was not pressed" do
      actionable = new_actionable(false)
      actionable.process_inputs
    
      actionable.num_of_updates.should == 0
    end
  
    it "should execute key event when key is pressed" do
      actionable = new_actionable(true)
      actionable.process_inputs
    
      actionable.num_of_updates.should == 1
    end
    
    it "should execute key event multiple times when it is repeatable" do
      actionable = new_actionable(true)
      2.times { actionable.process_inputs }
    
      actionable.num_of_updates.should == 2
    end
    
    it "should execute non repeatable key event once before clearing the button" do
      actionable = new_actionable(true, :repeatable => false)
      2.times { actionable.process_inputs }
    
      actionable.num_of_updates.should == 1
    end
    
    def new_actionable(is_button_down, options = {})
      mock_window = mock("game window")
      mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).at_least(1).and_return(is_button_down)
      actionable = SomeActionable.new(mock_window)
      actionable.when_key(Gosu::Button::KbLeft, options) { @num_of_updates += 1 }
    end
  end
  
  describe "(any key actions)" do
    it "should execute the 'any key' action when any button is pressed" do
      was_called = false
      actionable = SomeActionable.new(nil)
      actionable.any_key { was_called = true }

      actionable.button_down(nil)
      
      was_called.should be_true
    end
  end
  
  describe "(acting upon an external object)" do
    it "should act upon an external object" do
      external = Struct.new(:count).new
      external.count = 0
      
      mock_window = mock("game window")
      mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).and_return(true)
      actionable = SomeActionable.new(mock_window, external)
      actionable.when_key(Gosu::Button::KbLeft, options) { self.count += 1 }
      
      actionable.process_inputs
    
      external.count.should == 1
    end
  end
  
end