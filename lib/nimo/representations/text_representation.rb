module Nimo
  
  class TextRepresentation < ObjectRepresentation
    attr_accessor :color

    def initialize(game_window, game_object, params)
      super(game_window, game_object)
      @color = params[:color]
      @text = params[:text] # TODO Or should it get it from the game_object?
      
      @font_type = params.has_key?(:font) ? params[:font] : "Helvetica"
      @size = params.has_key?(:size) ? params[:size] : 20
    end
  
    def load
      @font = Gosu::Font.new(@game_window, @font_type, @size)
    end
  
    def draw
      @font.draw(@text, @game_object.x, @game_object.y, 0, 1, 1, @color)
    end
  
  end
  
end