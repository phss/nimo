require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::Screen do
  
  it "should register and execute event" do
    event_called = false
    
    screen = Nimo::Screen.new(:id, nil, nil)
    screen.listen_to(:on_enter) { event_called = true }
    
    event_called.should == false
    screen.notify(:on_enter)
    event_called.should == true
  end
  
  it "should register new representation" do
    screen = Nimo::Screen.new(:id, nil, nil)
    screen.respond_to?(:new_representation).should be_false

    Nimo::Screen.register_representation(:new_representation, nil)
    
    screen.respond_to?(:new_representation).should be_true
  end
  
  describe "(loading representations)" do
    before(:each) do
      @representation_class = mock("representation class")
      @representation = mock("representation")
      @representation_class.should_receive(:new).and_return(@representation)
      @screen = Nimo::Screen.new(:id, nil, nil)
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

  describe "(timer events)" do
    it "should not execute timer action before it's time" do
      was_called = false

      screen = Nimo::Screen.new(:id, nil, nil)
      screen.timer_for(100) { was_called = true }
      screen.update
      
      was_called.should be_false
    end
    
    it "should execute timer action only once" do
      number_of_executions = 0

      screen = Nimo::Screen.new(:id, nil, nil)
      screen.timer_for(0.1) { number_of_executions += 1 }
      sleep 1
      5.times { screen.update }
      
      number_of_executions.should == 1
    end
  end
 
  describe "(forwarding screen transition methods to game window)" do
    [:go_to, :open_menu, :close_menu].each do |method_name|
      it "should forward #{method_name} method to game_window" do
        mock_window = mock("window")
        mock_window.should_receive(method_name)

        Nimo::Screen.new(:id, mock_window, nil).send(method_name)
      end
    end
  end
  
  describe "(forwarding resource usage methods to resources)" do
    [:sounds, :images, :fonts].each do |method_name|
      it "should forward #{method_name} method to game_window" do
        resources = mock("resources")
        resources.should_receive(method_name)

        Nimo::Screen.new(:id, nil, resources).send(method_name)
      end
    end
  end
  
end
