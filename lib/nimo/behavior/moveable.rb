module Nimo::Behavior
  
  module Moveable
    
    def initialize(*params)
      @speed = 0
      @boundary = nil
      super(*params)
    end
    
    def move_left
      @x -= @speed
      @x = 0 if @boundary && @x < @boundary.x
    end

    def move_right
      @x += @speed
      @x = @boundary.width - @width if @boundary && (@x + @width) > @boundary.width
    end

    def move_up
      @y -= @speed
      @y = 0 if @boundary && @y < @boundary.y
    end

    def move_down
      @y += @speed
      @y = @boundary.height - @height if @boundary && (@y + @height) > @boundary.height
    end
    
  end
  
end