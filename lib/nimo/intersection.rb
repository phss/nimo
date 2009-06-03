module Nimo
  class Intersection
  
    attr_reader :x, :y, :width, :height
  
    def initialize(x, y, width, height)
      @x = x
      @y = y
      @width = width
      @height = height
    end
  
    def self.between(obj1, obj2)
      x = [obj1.x, obj2.x].max
      y = [obj1.y, obj2.y].max
      width = [obj1.x + obj1.width, obj2.x + obj2.width].min - x
      height = [obj1.y + obj1.height, obj2.y + obj2.height].min - y
      return Intersection.new(x, y, width, height)
    end
    
    def collistion_side_for(obj)
      if @width >= @height
        return obj.y_center > (@y + (@height/2)) ? :top : :bottom
      else
        return obj.x_center > (@x + (@width/2)) ? :left : :right
      end
    end
    
  end
end