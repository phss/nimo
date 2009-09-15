require File.dirname(__FILE__) + '/../../spec_helper'

describe "Nimo::Game module method" do
  
  before(:each) do
    @game_window = mock("game window")
    Nimo::GameWindow.should_receive(:new).with("title", 320, 240).and_return(@game_window)
    @game_window.should_receive(:show)
  end
  
  it "should construct and show a GameWindow with title and dimenstion attributes" do
    window = Nimo::Game("title", 320, 240)
  end
  
  it "should construct and show a GameWindow with a construction block" do
    @game_window.should_receive(:add_screen)
    
    window = Nimo::Game("title", 320, 240) do
      screen :some_screen
    end
  end
  
  
  # describe "(screen construction)" do
  #   it "should add a new screen with the supplied screen building block" do
  #     screen = mock("screen")
  #     Nimo::Screen.should_receive(:new).and_return(screen)
  #     screen.should_receive(:quad).with(:something)
  #     screen.should_receive(:notify)
  #     
  #     @game_window.screen :name do
  #       quad :something
  #     end
  #   end
  #   
  #   it "should forward image loading to the Resources" do
  #     image_def = {:some_tag => { :filename => "some file name.png" }}
  #     @resources.should_receive(:load_images).with(image_def)
  #     
  #     @game_window.images(image_def)
  #   end
  # end
  
end