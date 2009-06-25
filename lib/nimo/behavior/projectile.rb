module Nimo::Behavior 
  
  module Projectile
		include WithVelocity
    
    def initialize(*params)
      @deflectors = []
      super(*params)
    end
    
    def move
      @deflectors.each { |deflector| deflector.deflect(self) }
			super
    end
    
    def with_deflectors(*new_deflectors)
      @deflectors += new_deflectors
      @deflectors.flatten!
    end

  end
  
end
