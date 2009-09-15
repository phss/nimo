require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::GameWindow do
  
  before(:each) do
    @game_window = Nimo::GameWindow.new("Test", 640, 480)
  end
  
  describe "(screen transition)" do 
    before(:each) do
      @game_window.add_screen(:first, Nimo::Screen.new(:first, nil, nil))
      @game_window.add_screen(:second, Nimo::Screen.new(:second, nil, nil))
      @game_window.add_screen(:third, Nimo::Screen.new(:third, nil, nil))
    end
     
    it "should have the first screen added as the current screen" do
      @game_window.current_screen.id.should == :first
    end
  
    it "should cycle through available screens" do
      @game_window.go_to(:second)
      @game_window.current_screen.id.should == :second
      @game_window.go_to(:third)
      @game_window.current_screen.id.should == :third
      @game_window.go_to(:first)
      @game_window.current_screen.id.should == :first
    end
  
    it "should open and close a 'menu' screen" do
      @game_window.open_menu(:second)
      @game_window.current_screen.id.should == :second
      @game_window.open_menu(:third)
      @game_window.current_screen.id.should == :third
      @game_window.close_menu
      @game_window.current_screen.id.should == :second
      @game_window.close_menu
      @game_window.current_screen.id.should == :first
    end
    
    it "should throw error if screen is not available" do
      lambda { @game_window.go_to(:wrong_screen) }.should raise_error("There is no screen named wrong_screen")
    end
  
  end
  
  describe "(game loop)" do
    it "should proxy updates and draws to current screen" do
      mock_screen = new_mock_screen("screen")

      expect(:update, mock_screen)
      expect(:draw, mock_screen)
    end
    
    it "should proxy draws to background screens" do
      mock_screen1 = new_mock_screen("mock1")
      mock_screen2 = new_mock_screen("mock2")

      @game_window.open_menu("mock2")

      expect(:update, mock_screen2)
      expect(:draw, mock_screen1, mock_screen2)
    end

    it "should not proxy draw for background screen after closing the menu" do
      mock_screen1 = new_mock_screen("mock1")
      mock_screen2 = new_mock_screen("mock2")
      
      @game_window.open_menu("mock2")
      @game_window.close_menu

      expect(:update, mock_screen1)
      expect(:draw, mock_screen1)
    end
    
    def new_mock_screen(name)
      mock_screen = mock(name)
      mock_screen.should_receive(:notify).once
      @game_window.add_screen(name, mock_screen)
      return mock_screen
    end
    
    def expect(method_name, *instances)
      instances.each { |instance| instance.should_receive(method_name) }
      @game_window.send(method_name)
    end
  end
  
end