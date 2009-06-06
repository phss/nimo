module Nimo
  
  class ImageRepresentation < ObjectRepresentation
  
    def initialize(game_window, game_object, params)
      super(game_window, game_object)
      @image = Gosu::Image.new(@game_window, params[:file], 0)
    end
  
    def draw
      @image.draw(@game_object.x, @game_object.y, 0)
    end  
  end
  
end