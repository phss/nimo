require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::Screen do
  
  it "should register and execute event" do
    event_called = false
    
    screen = Nimo::Screen.new(nil, nil)
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
  
  describe "(forwarding screen transition methods to game window)" do
    [:go_to, :open_menu, :close_menu].each do |method_name|
      it "should forward #{method_name} method to game_window" do
        mock_window = mock("window")
        mock_window.should_receive(method_name)

        Nimo::Screen.new(mock_window, nil).send(method_name)
      end
    end
  end
  
end