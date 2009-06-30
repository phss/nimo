module Nimo
  class ResourceLoader

    def initialize(game_window)
      @game_window = game_window
      @resources = {}
    end
  
    # TODO add tests and a more unified loading
    def load_image(filename)
      load_resource(filename) { Gosu::Image.new(@game_window, filename, 0) }
    end
  
    def load_image_tiles(filename, tile_width, tile_height)
      load_resource(filename) { Gosu::Image.load_tiles(@game_window, filename, tile_width, tile_height, false) }
    end

    def load_sound(filename)
      load_resource(filename) { Gosu::Song.new(@game_window, filename) }
    end

    private

    def load_resource(filename)
      @resources[filename] ||= yield
    end
  
  end
end
