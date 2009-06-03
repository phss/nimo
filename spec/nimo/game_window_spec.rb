require File.dirname(__FILE__) + '/../spec_helper'

describe Nimo::GameWindow do
  
  before(:each) do
    @game_window = Nimo::GameWindow.new("Test", 640, 480)
  end
  
  it "should have the first screen added as the current screen" do
    @game_window.add_screens_by_class(FirstStubScreen, SecondStubScreen, ThirdStubScreen)
    @game_window.current_screen.should be_an_instance_of(FirstStubScreen)
  end
  
  it "should proxy updates and draws to current screen" do
    mock_screen = mock("screen")
    @game_window.add_screen("mock", mock_screen)
    
    mock_screen.should_receive(:update).once
    @game_window.update

    mock_screen.should_receive(:draw).once
    @game_window.draw
  end
  
  it "should cycle through available screens" do
    @game_window.add_screens_by_class(FirstStubScreen, SecondStubScreen, ThirdStubScreen)
    @game_window.go_to("SecondStub")
    @game_window.current_screen.should be_an_instance_of(SecondStubScreen)
    @game_window.go_to("ThirdStub")
    @game_window.current_screen.should be_an_instance_of(ThirdStubScreen)
    @game_window.go_to("FirstStub")
    @game_window.current_screen.should be_an_instance_of(FirstStubScreen)
  end
  
  it "should throw error if screen is not available" do
    @game_window.add_screens_by_class(FirstStubScreen)
    lambda { @game_window.go_to("WrongScreen") }.should raise_error("There is no screen named WrongScreen")
  end
  
end

class FirstStubScreen < Nimo::Screen; end
class SecondStubScreen < Nimo::Screen; end
class ThirdStubScreen < Nimo::Screen; end