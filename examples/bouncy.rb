$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

PAD_CONFIG = { :x => 200, :y => 400, :width => 80, :height => 15}
BALL_CONFIG = { :x => 200, :y => 200, :width => 10, :height => 10}

class GameScreen < Nimo::Screen
  
  def initialize(game_window)
    super(game_window)
  end
  
  def initialize_representations
    representations = []
    
    pad_obj = Pad.new(PAD_CONFIG)
    pad = Nimo::QuadRepresentation.new(@game_window, pad_obj, Gosu::white)
    pad.when_key(Gosu::Button::KbLeft) { move_left }
    pad.when_key(Gosu::Button::KbRight) { move_right }
    representations << pad
    
    ball = Nimo::QuadRepresentation.new(@game_window, Ball.new(BALL_CONFIG, pad_obj, Wall.sections), Gosu::red)
    ball.always { move }
    representations << ball
    
    return representations.flatten
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end



class Deflector < Nimo::GameObject
  
  def initialize(config_options={:x => 0, :y => 0, :width => 0, :height => 0})
    super(config_options)
    @deflect_action = nil
    @collision_timeout = 0
  end
  
  def deflect_and_adjust(ball)
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
    
    ball.velocity.adjust(deflection_modifier(ball))
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


class Pad < Deflector
  
  def initialize(config)
    super(config)
  end
  
  def move_left
    @x -= 5
    @x = 0 if @x < 0 # FIXME move this logic elsewhere?
  end
  
  def move_right
    @x += 5
    @x = WINDOW_WIDTH - @width if (@x + @width) > WINDOW_WIDTH # FIXME move this logic elsewhere?
  end
  
  def deflection_modifier(ball)
    (ball.x_center - self.x_center)/(1.5*@width)
  end
  
end


class Wall
  
  def self.sections
    [
      Deflector.new({:x => -10, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10}),
      Deflector.new({:x => -10, :y => -10, :width => WINDOW_WIDTH + 10, :height => 10}),
      Deflector.new({:x => WINDOW_WIDTH, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10})
    ]
  end
    
end


Velocity = Struct.new(:x, :y) do
  def adjust(radian)
    xl = Math::cos(radian)*self.x - Math::sin(radian)*self.y
    yl = Math::sin(radian)*self.x + Math::cos(radian)*self.y
    self.x = xl
    self.y = yl
  end
end

class Ball < Nimo::GameObject
  
  attr_reader :velocity
  
  def initialize(config, *deflectors)
    configure_with(config)
    @deflectors = deflectors.flatten
    
    @speed = 5
    @velocity = Velocity.new(0.0, 1.0)
    @velocity.adjust(-0.2)
  end
    
  def move
    @deflectors.each { |deflector| deflector.deflect_and_adjust(self) }
    @x += @speed * @velocity.x
    @y += @speed * @velocity.y
  end

  def add_deflector(deflector)
    @deflectors << deflector
  end
  
  def remove_deflector(deflector)
    @deflectors.delete(deflector)
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Bouncy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(GameScreen)
  window.show
end