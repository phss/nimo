module Nimo::Behavior
  
  module Projectile
    attr_reader :velocity
    
    def initialize(*params)
      @speed = 0
      @velocity = Struct.new(:x, :y).new(0.0, 0.0)
      @deflectors = []
      super(*params)
    end
    
    def move
      @deflectors.each { |deflector| deflector.deflect(self) }
      @x += @speed * @velocity.x
      @y += @speed * @velocity.y
    end
    
    def with_deflectors(*new_deflectors)
      @deflectors += new_deflectors
      @deflectors.flatten!
    end

  end
  
end