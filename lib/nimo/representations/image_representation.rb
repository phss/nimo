module Nimo
  
  class ImageRepresentation < ObjectRepresentation
  
    def initialize(game_window, game_object, params)
      super(game_window, game_object)
      @file = params[:file]
      @index = params[:index]
    end
    
    def load
      if @index.nil?
        @image = Gosu::Image.new(@game_window, @file, 0)
      else
        @image = Gosu::Image.load_tiles(@game_window, @file, @game_object.width, @game_object.height, false)[@index]
      end
    end
  
    def draw
      @image.draw(@game_object.x, @game_object.y, 0)
    end
  end
  
end