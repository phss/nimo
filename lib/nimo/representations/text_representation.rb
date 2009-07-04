module Nimo
  
  class TextRepresentation < ObjectRepresentation
    attr_accessor :color
    
    def load(resources, params)
      @font = resources.fonts[params[:font]]
      @color = params[:color]
      @text = params[:text] # TODO Or should it get it from the game_object?
    end
  
    def draw
      @font.draw(@text, @game_object.x, @game_object.y, 0, 1, 1, @color)
    end
  
  end
  
end