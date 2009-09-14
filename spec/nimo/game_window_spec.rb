require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::GameWindow do
  
  before(:each) do
    @resources = mock("resources")
    Nimo::Resources.should_receive(:new).and_return(@resources)
    @game_window = Nimo::GameWindow.new("Test", 640, 480)
  end
  
  describe "(screen construction)" do
    it "should add a new screen with the supplied screen building block" do
      screen = mock("screen")
      Nimo::Screen.should_receive(:new).and_return(screen)
      screen.should_receive(:quad).with(:something)
      screen.should_receive(:notify)
      
      @game_window.screen :name do
        quad :something
      end
    end
    
    it "should forward image loading to the Resources" do
      image_def = {:some_tag => { :filename => "some file name.png" }}
      @resources.should_receive(:load_images).with(image_def)
      
      @game_window.images(image_def)
    end
  end
  
  describe "(screen transition)" do 
    before(:each) do
      @game_window.screen :first
      @game_window.screen :second
      @game_window.screen :third
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

      mock_screen.should_receive(:update).once
      @game_window.update

      mock_screen.should_receive(:draw).once
      @game_window.draw
    end
    
    it "should proxy draws to background screens" do
      mock_screen1 = new_mock_screen("mock1")
      mock_screen2 = new_mock_screen("mock2")

      @game_window.open_menu("mock2")

      mock_screen2.should_receive(:update).once
      @game_window.update

      mock_screen1.should_receive(:draw).once
      mock_screen2.should_receive(:draw).once
      @game_window.draw
    end

    it "should not proxy draw for background screen after closing the menu" do
      mock_screen1 = new_mock_screen("mock1")
      mock_screen2 = new_mock_screen("mock2")
      
      @game_window.open_menu("mock2")
      @game_window.close_menu

      mock_screen1.should_receive(:update).once
      @game_window.update

      mock_screen1.should_receive(:draw).once
      @game_window.draw
    end
    
    def new_mock_screen(name)
      mock_screen = mock(name)
      mock_screen.should_receive(:notify).once
      @game_window.add_screen(name, mock_screen)
      return mock_screen
    end
  end
  
end