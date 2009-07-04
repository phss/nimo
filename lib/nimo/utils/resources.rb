module Nimo
  
  # 
  # Builder to create a Resource.
  # 
  class Resources

    attr_reader :images, :fonts, :sounds

    def initialize(game_window)
      @game_window = game_window
      @images = {}
      @fonts  = {}
      @sounds = {}
    end
  
    def with_image(tag, filename)
      @images[tag] ||= Gosu::Image.new(@game_window, filename, 0)
      self
    end
  
    def with_image_tiles(tag, filename, tile_width, tile_height)
      @images[tag] ||= Gosu::Image.load_tiles(@game_window, filename, tile_width, tile_height, false)
      self
    end

    def with_font(tag, font_type, size)
      @fonts[tag] ||= Gosu::Font.new(@game_window,font_type, size)
      self
    end

    def with_sound(tag, filename)
      @sounds[tag] ||= Gosu::Song.new(@game_window, filename)
      self
    end
  end
end
