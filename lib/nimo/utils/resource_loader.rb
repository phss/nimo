class ResourceLoader

  def initialize(game_window)
    @game_window = game_window
    @resources = {}
  end
  
  def load_image(filename)
    if !@resources.has_key?(filename)
      @resources[filename] = Gosu::Image.new(@game_window, filename, 0)
    end
    return @resources[filename]
  end
  
  def load_image_tiles(filename, tile_width, tile_height)
    if !@resources.has_key?(filename)
      @resources[filename] = Gosu::Image.load_tiles(@game_window, filename, tile_width, tile_height, false)
    end
    return @resources[filename]
  end
  
end