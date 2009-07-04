require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::Resources do
  
  it "should build Resources as a builder" do
    Gosu::Image.should_receive(:new).and_return(nil)
    Gosu::Image.should_receive(:load_tiles).and_return(nil)
    Gosu::Song.should_receive(:new).and_return(nil)
    Gosu::Font.should_receive(:new).and_return(nil)
    
    resources = Nimo::Resources.new(nil).
      with_image(:some_image, "some_file.png").
      with_image_tiles(:some_tile, "some_file.png", 32, 32).
      with_sound(:some_sound, "some_file.png").
      with_font(:some_font, "name", 12)
      
    resources.images.should have_key(:some_image)
    resources.images.should have_key(:some_tile)
    resources.sounds.should have_key(:some_sound)
    resources.fonts.should have_key(:some_font)
  end
  
end