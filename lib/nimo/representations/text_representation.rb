module Nimo
  
  class TextRepresentation < ObjectRepresentation
    represent :text
    attr_accessor :color
    
    def load(resources, params)
      validate(params)
      
      @font = resources.font(params[:font])
      @color = params[:color]
      @text = params[:text] # TODO Or should it get it from the game_object?
    end
  
    def draw
      @font.draw(@text, @game_object.x, @game_object.y, 0, 1, 1, @color)
    end
    
    private
    
    def validate(params)
      [:font, :color, :text].each { |param| raise "Must provide :#{param} param for font loading" unless params.has_key?(param) }
    end
  
  end
  
end