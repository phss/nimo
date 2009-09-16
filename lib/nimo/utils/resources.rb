module Nimo
  
  # Resource loader.
  # 
  class Resources

    attr_reader :images, :fonts, :sounds

    def initialize(game_window)
      @game_window = game_window
      @images = {}
      @fonts  = {}
      @sounds = {}
    end
    
    def load_images(image_definitions)
      image_definitions.each { |tag, definition| @images[tag] ||= create_image_from(definition) }
    end
    
    def load_fonts(font_definitions)
      font_definitions.each { |tag, definition| @fonts[tag] ||= Gosu::Font.new(@game_window, definition[:type], definition[:size]) }
    end
    
    def load_sounds(sound_definitions)
      sound_definitions.each { |tag, definition| @sounds[tag] ||= Gosu::Song.new(@game_window, definition[:filename]) }
    end
    
    def method_missing(meth, *args, &blk)
      super unless [:image, :sound, :font].include?(meth)
      validate_and_return_resource(meth, args.shift)
    end

    private
    
    def create_image_from(definition)
      if definition.has_key?(:tile_dimension)
        width = definition[:tile_dimension][0]
        height = definition[:tile_dimension][1]
        return Gosu::Image.load_tiles(@game_window, definition[:filename], width, height, false)
      end
      return Gosu::Image.new(@game_window, definition[:filename], 0)
    end
    
    def validate_and_return_resource(resource_type, tag)
      resource_list = self.send("#{resource_type.to_s}s")
      raise "No #{resource_type.to_s} resource named '#{tag}'" unless resource_list.has_key?(tag)
      resource_list[tag]
    end
    
  end
end
