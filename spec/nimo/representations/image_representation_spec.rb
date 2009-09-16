require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::ImageRepresentation do
  
  before(:each) do
    @resources = mock("resources")
    @image_file = mock("image file")    
    @game_object = Nimo::GameObject.new(:x => 0, :y => 0, :width => 10, :height => 10)
  end
  
  it "should load image from resources and draw it" do
    expect_image_access(:some_file_tag => @image_file)
    representation = load_representation(:image => :some_file_tag)
    
    @image_file.should_receive(:draw)
    representation.draw
  end
  
  it "should load image from tile resource and draw it" do
    expect_image_access(:some_file_tag => [nil, @image_file, nil])
    representation = load_representation(:image => :some_file_tag, :index => 1)
    
    @image_file.should_receive(:draw)
    representation.draw
  end

	it "should raise exception when loading with a missing :image param" do
		lambda { load_representation({}) }.should raise_error("Must provide :image param for image loading")
	end

	def load_representation(params)
    representation = Nimo::ImageRepresentation.new(nil, @game_object)
    representation.load(@resources, params)
		return representation
	end

	def expect_image_access(image_map)
		@resources.stub!(:images).and_return(image_map)
	end
  
end
