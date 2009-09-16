require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::Resources do
  
  before(:each) do
    @resources = Nimo::Resources.new(nil) 
  end
  
  it "should load images" do
    some_image = mock("image")
    Gosu::Image.should_receive(:new).and_return(some_image)
    
    @resources.load_images(:some_image => { :filename => "some_file.png" })
    
    @resources.images.should have_key(:some_image)
    @resources.image(:some_image).should == some_image
  end
  
  it "should raise exception when trying to get an unknown image" do
    lambda { @resources.image(:unknown) }.should raise_error("No image resource named 'unknown'")
  end
  
  it "should load tiled images" do
    Gosu::Image.should_receive(:load_tiles).and_return(nil)
    
    @resources.load_images(:some_tile => { :filename => "some_file.png", :tile_dimension => [32, 32] })
    
    @resources.images.should have_key(:some_tile)
  end
  
  it "should load fonts" do
    some_font = mock("font")
    Gosu::Font.should_receive(:new).and_return(some_font)
    
    @resources.load_fonts(:some_font => { :type => "some_font_name", :size => 42 })
    
    @resources.fonts.should have_key(:some_font)
    @resources.font(:some_font).should == some_font
  end
  
  it "should raise exception when trying to get an unknown font" do
    lambda { @resources.font(:unknown) }.should raise_error("No font resource named 'unknown'")
  end
  
  it "should load sounds" do
    some_sound = mock("sound")
    Gosu::Song.should_receive(:new).and_return(some_sound)
    
    @resources.load_sounds(:some_sound => { :filename => "some_file.wav" })
    
    @resources.sounds.should have_key(:some_sound)
    @resources.sound(:some_sound).should == some_sound
  end
  
  it "should raise exception when trying to get an unknown sound" do
    lambda { @resources.sound(:unknown) }.should raise_error("No sound resource named 'unknown'")
  end
  
end