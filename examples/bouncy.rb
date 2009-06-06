$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480


class GameScreen < Nimo::Screen
  
  def initialize_representations
    pad_obj = Pad.new
    
    [ Nimo::QuadRepresentation.new(@game_window, pad_obj, Gosu::white).
        when_key(Gosu::Button::KbLeft) { move_left }.
        when_key(Gosu::Button::KbRight) { move_right }.
        when_key(Gosu::Button::KbUp) { move_up }.
        when_key(Gosu::Button::KbDown) { move_down },
      Nimo::QuadRepresentation.new(@game_window, Ball.new(pad_obj, Wall.sections), Gosu::red).
        always { move } ]
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end


class Pad < Nimo::GameObject
  include Nimo::Behavior::Deflector
  
  def initialize
    super(:x => 200, :y => 400, :width => 80, :height => 40)
  end
  
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


class Wall < Nimo::GameObject
  include Nimo::Behavior::Deflector
  
  def self.sections
    [ Wall.new({:x => -10, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10}),
      Wall.new({:x => -10, :y => -10, :width => WINDOW_WIDTH + 10, :height => 10}),
      Wall.new({:x => WINDOW_WIDTH, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10}),
      Wall.new({:x => -10, :y => WINDOW_HEIGHT, :width => WINDOW_WIDTH, :height => 10}) ]
  end
end


class Ball < Nimo::GameObject
  include Nimo::Behavior::Projectile
  
  def initialize(*deflectors)
    super(:x => 200, :y => 200, :width => 10, :height => 10, :velocity => Struct.new(:x, :y).new(0.2, 0.7))
    @deflectors = deflectors.flatten
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Bouncy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(GameScreen)
  window.show
end