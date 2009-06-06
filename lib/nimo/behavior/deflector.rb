module Nimo::Behavior
  
  module Deflector
    
    def deflect(ball)
      @collision_timeout ||= 0
      @collision_timeout -= 1 if @collision_timeout > 0
      return unless @collision_timeout.zero? && collide?(ball)

      case intersection(ball).collistion_side_for(self)
        when :top
          ball.velocity.y = -ball.velocity.y.abs
        when :bottom
          ball.velocity.y = ball.velocity.y.abs
        when :left
          ball.velocity.x = -ball.velocity.x.abs
        when :right
          ball.velocity.x = ball.velocity.x.abs
      end

      ball.velocity.adjust(deflection_modifier(ball)) if deflection_modifier(ball) != 0
      @deflect_action.call() if @deflect_action
      @collision_timeout = 5
    end

    def when_deflect(&action)
      @deflect_action = action
    end

    protected

    def deflection_modifier(ball)
      0
    end
    
  end
  
end