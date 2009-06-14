module Nimo
  
  class ImageRepresentation < ObjectRepresentation
  
    def initialize(game_window, game_object, params)
      super(game_window, game_object)
      @file = params[:file]
      @index = params[:index]
    end
    
    def load
      if @index.nil?
        @image = @game_window.resource_loader.load_image(@file)
      else
        @image = @game_window.resource_loader.load_image_tiles(@file, @game_object.width, @game_object.height)[@index]
      end
    end
  
    def draw
      @image.draw(@game_object.x, @game_object.y, 0)
    end
  end
  
end