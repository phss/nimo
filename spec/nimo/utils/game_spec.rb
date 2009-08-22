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
    @game_window.should_receive(:screen).with(:some_screen)
    
    window = Nimo::Game("title", 320, 240) do
      screen :some_screen
    end
  end
  
end