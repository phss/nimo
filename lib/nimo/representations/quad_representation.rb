module Nimo
  
  class QuadRepresentation < ObjectRepresentation
    attr_accessor :color
  
    def initialize(game_window, game_object, params)
      super(game_window, game_object)
      @color = params[:color]
    end
  
    def draw
      @game_window.draw_quad(
        @game_object.x, @game_object.y, @color, 
        @game_object.x + @game_object.width, @game_object.y, @color,
        @game_object.x, @game_object.y + @game_object.height, @color,
        @game_object.x + @game_object.width, @game_object.y + @game_object.height, @color)
    end
  
  end
  
end