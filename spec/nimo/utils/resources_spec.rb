require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::Resources do
  
  before(:each) do
    @resources = Nimo::Resources.new(nil) 
  end
  
  it "should load images" do
    Gosu::Image.should_receive(:new).and_return(nil)
    
    @resources.load_images(:some_image => { :filename => "some_file.png" })
    
    @resources.images.should have_key(:some_image)
  end
  
  it "should load tiled images" do
    Gosu::Image.should_receive(:load_tiles).and_return(nil)
    
    @resources.load_images(:some_tile => { :filename => "some_file.png", :tile_dimension => [32, 32] })
    
    @resources.images.should have_key(:some_tile)
  end
  
  it "should build Resources as a builder" do
    Gosu::Song.should_receive(:new).and_return(nil)
    Gosu::Font.should_receive(:new).and_return(nil)
    
    resources = Nimo::Resources.new(nil).
      with_sound(:some_sound, "some_file.png").
      with_font(:some_font, "name", 12)
      
    resources.sounds.should have_key(:some_sound)
    resources.fonts.should have_key(:some_font)
  end
  
end