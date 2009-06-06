module Nimo::Behavior
  
  module Deflector
    
    def deflect(projectile)
      @collision_timeout ||= 0
      @collision_timeout -= 1 if @collision_timeout > 0
      return unless @collision_timeout.zero? && collide?(projectile)

      case intersection(projectile).collistion_side_for(self)
        when :top
          projectile.velocity.y = -projectile.velocity.y.abs
        when :bottom
          projectile.velocity.y = projectile.velocity.y.abs
        when :left
          projectile.velocity.x = -projectile.velocity.x.abs
        when :right
          projectile.velocity.x = projectile.velocity.x.abs
      end

      projectile.velocity.adjust(deflection_modifier(projectile))
      @deflect_action.call() if @deflect_action
      @collision_timeout = 5
    end

    def when_deflect(&action)
      @deflect_action = action
    end

    protected

    def deflection_modifier(projectile)
      0
    end
    
  end
  
end