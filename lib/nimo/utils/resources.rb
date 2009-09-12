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

    def with_font(tag, font_type, size)
      @fonts[tag] ||= Gosu::Font.new(@game_window,font_type, size)
      self
    end

    def with_sound(tag, filename)
      @sounds[tag] ||= Gosu::Song.new(@game_window, filename)
      self
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
    
  end
end
