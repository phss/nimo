$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480


class GameScreen < Nimo::Screen
  
  def initialize_representations
    pad_obj = Pad.new({ :x => 200, :y => 400, :width => 80, :height => 40})
    
    [ Nimo::QuadRepresentation.new(@game_window, pad_obj, Gosu::white).
        when_key(Gosu::Button::KbLeft) { move_left }.
        when_key(Gosu::Button::KbRight) { move_right }.
        when_key(Gosu::Button::KbUp) { move_up }.
        when_key(Gosu::Button::KbDown) { move_down },
      Nimo::QuadRepresentation.new(@game_window, Ball.new({ :x => 200, :y => 200, :width => 10, :height => 10}, pad_obj, Wall.sections), Gosu::red).
        always { move } ]
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end


class Deflector < Nimo::GameObject
  
  def initialize(config_options)
    super(config_options)
    @collision_timeout = 0
  end
  
  def deflect(ball)
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
    
    @collision_timeout = 5
  end
    
end


class Pad < Deflector
  
  def move_left
    @x -= 5
    @x = 0 if @x < 0
  end
  
  def move_right
    @x += 5
    @x = WINDOW_WIDTH - @width if (@x + @width) > WINDOW_WIDTH
  end
  
  def move_up
    @y -= 5
    @y = 0 if @y < 0
  end
  
  def move_down
    @y += 5
    @y = WINDOW_HEIGHT - @height if (@y + @height) > WINDOW_HEIGHT
  end
  
end


class Wall
  def self.sections
    [ Deflector.new({:x => -10, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10}),
      Deflector.new({:x => -10, :y => -10, :width => WINDOW_WIDTH + 10, :height => 10}),
      Deflector.new({:x => WINDOW_WIDTH, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10}),
      Deflector.new({:x => -10, :y => WINDOW_HEIGHT, :width => WINDOW_WIDTH, :height => 10}) ]
  end
end


class Ball < Nimo::GameObject
  
  attr_reader :velocity
  
  def initialize(config, *deflectors)
    configure_with(config)
    @deflectors = deflectors.flatten
    
    @speed = 5
    @velocity = Struct.new(:x, :y).new(0.2, 0.7)
  end
    
  def move
    @deflectors.each { |deflector| deflector.deflect(self) }
    @x += @speed * @velocity.x
    @y += @speed * @velocity.y
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Bouncy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(GameScreen)
  window.show
end