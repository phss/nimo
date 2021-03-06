require File.dirname(__FILE__) + '/../../spec_helper'

describe "Nimo::InputListener module" do
  
  class SomeInputListener
    include Nimo::InputListener
    attr_reader :num_of_updates
    
    def initialize(acting_upon = self)
      @num_of_updates = 0
      @acting_upon = acting_upon
    end
    
    def act_upon
      @acting_upon
    end
  end
  
  before(:each) do
    @mock_window = mock("game window")
  end
  
  describe "(key actions)" do
    it "should not execute key event when key was not pressed" do
      listener = new_listener(false)
      listener.process_inputs(@mock_window)
    
      listener.num_of_updates.should == 0
    end
  
    it "should execute key event when key is pressed" do
      listener = new_listener(true)
      listener.process_inputs(@mock_window)
    
      listener.num_of_updates.should == 1
    end
    
    it "should execute key event multiple times when it is repeatable" do
      listener = new_listener(true)
      2.times { listener.process_inputs(@mock_window) }
    
      listener.num_of_updates.should == 2
    end
    
    it "should execute non repeatable key event once before clearing the button" do
      listener = new_listener(true, :repeatable => false)
      2.times { listener.process_inputs(@mock_window) }
    
      listener.num_of_updates.should == 1
    end
    
    def new_listener(is_button_down, options = {})
      @mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).at_least(1).and_return(is_button_down)
      listener = SomeInputListener.new
      listener.when_key(Gosu::Button::KbLeft, options) { @num_of_updates += 1 }
      return listener
    end
  end
  
  describe "(any key actions)" do
    it "should execute the 'any key' action when any button is pressed" do
      was_called = false
      listener = SomeInputListener.new(nil)
      listener.any_key { was_called = true }

      listener.button_down(nil)
      
      was_called.should be_true
    end
  end
  
  describe "(acting upon an external object)" do
    it "should act upon an external object" do
      external = Struct.new(:count).new
      external.count = 0
      
      @mock_window.should_receive(:button_down?).with(Gosu::Button::KbLeft).and_return(true)
      listener = SomeInputListener.new(external)
      listener.when_key(Gosu::Button::KbLeft, options) { self.count += 1 }
      
      listener.process_inputs(@mock_window)
    
      external.count.should == 1
    end
  end
  
end