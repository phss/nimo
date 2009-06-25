module Nimo::Behavior
  
  Velocity = Struct.new(:x, :y) do
    def adjust(radian)
      xl = Math::cos(radian)*self.x - Math::sin(radian)*self.y
      yl = Math::sin(radian)*self.x + Math::cos(radian)*self.y
      self.x = xl
      self.y = yl
    end
  end
  
  module WithVelocity
    attr_reader :velocity
    
    def initialize(*params)
      @speed = 0
      @velocity = Velocity.new(0.0, 0.0)
      super(*params)
    end
    
    def move
      @x += @speed * @velocity.x
      @y += @speed * @velocity.y
    end

  end
  
end
