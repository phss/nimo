require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::ImageRepresentation do
  
  before(:each) do
    @resources = mock("resources")
    @image_file = mock("image file")    
    @game_object = Nimo::GameObject.new(:x => 0, :y => 0, :width => 10, :height => 10)
  end
  
  it "should load image from resources and draw it" do
    @resources.stub!(:images).and_return({:some_file_tag => @image_file})
    representation = Nimo::ImageRepresentation.new(nil, @game_object)
    representation.load(@resources, :image => :some_file_tag)
    
    @image_file.should_receive(:draw)
    representation.draw
  end
  
  it "should load image from tile resource and draw it" do
    @resources.stub!(:images).and_return({:some_file_tag => [nil, @image_file, nil]})
    representation = Nimo::ImageRepresentation.new(nil, @game_object)
    representation.load(@resources, :image => :some_file_tag, :index => 1)
    
    @image_file.should_receive(:draw)
    representation.draw
  end
  
end