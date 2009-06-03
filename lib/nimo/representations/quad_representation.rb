module Nimo
  
  class QuadRepresentation < ObjectRepresentation
  
    def initialize(game_window, game_object, quad_color)
      super(game_window, game_object)
      @quad_color = quad_color
    end
  
    def draw
      @game_window.draw_quad(
        @game_object.x, @game_object.y, @quad_color, 
        @game_object.x + @game_object.width, @game_object.y, @quad_color,
        @game_object.x, @game_object.y + @game_object.height, @quad_color,
        @game_object.x + @game_object.width, @game_object.y + @game_object.height, @quad_color)
    end
  
  end
  
end