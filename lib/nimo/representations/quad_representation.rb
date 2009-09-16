module Nimo
  
  class QuadRepresentation < ObjectRepresentation
    represent :quad
    attr_accessor :color
     
    def load(resources, params)
      raise "Must provide :color param for quad loading" unless params.has_key?(:color)
      
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
