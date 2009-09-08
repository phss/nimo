module Nimo
  
  class QuadRepresentation < ObjectRepresentation
    attr_accessor :color
    
    # FIXME: Fix this to have a method on ObjectRepresentation that registers.
    Screen.register_representation(:quad, self)
      
    def load(resources, params)
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