module Nimo
  
  class TextRepresentation < ObjectRepresentation
    represent :text
    attr_accessor :color
    
    # FIXME: create a definition requirement...or something...to validate when we don't have a font
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