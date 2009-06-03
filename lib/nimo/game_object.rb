module Nimo
  
  class GameObject
    attr_accessor :x, :y, :width, :height
      
    def initialize(config_options={:x => 0, :y => 0, :width => 0, :height => 0})
      configure_with(config_options)
    end
  
    def at(x, y)
      @x = x
      @y = y
    end
  
    def dimension(width, height)
      @width = width
      @height = height
    end
    
    # config_options is a hash that can take the following keys: :x, :y, :width, :height. 
    # The key restriction is not being enforced.
    def configure_with(config_options)
      config_options.each { |attribute, value| eval "self.#{attribute} = #{value}" }
    end
  
    def collide?(obj)
      !(obj.x > (@x + @width)  || @x > (obj.x + obj.width) ||
        obj.y > (@y + @height) || @y > (obj.y + obj.height))
    end
    
    def intersection(obj)
      return collide?(obj) ? Intersection.between(self, obj) : nil
    end

    def x_center
      @x + (@width/2)
    end

    def y_center
      @y + (@height/2)
    end
  
  end
  
end