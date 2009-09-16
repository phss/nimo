require File.dirname(__FILE__) + '/../../spec_helper'

describe Nimo::TextRepresentation do

	it "should raise exception when loading with a missing :image param" do
		lambda { load_representation_with(:text => :some_text, :color => :some_color) }.should raise_error("Must provide :font param for font loading")
	end
	
	it "should raise exception when loading with a missing :color param" do
		lambda { load_representation_with(:text => :some_text, :font => :some_font) }.should raise_error("Must provide :color param for font loading")
	end
	
	it "should raise exception when loading with a missing :text param" do
		lambda { load_representation_with(:font => :some_font, :color => :some_color) }.should raise_error("Must provide :text param for font loading")
	end
	
	def load_representation_with(params)
    Nimo::TextRepresentation.new(nil, nil).load(nil, params) 
	end

end
