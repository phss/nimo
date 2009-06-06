$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480


class GameScreen < Nimo::Screen
  
  def representations
    pad = Pad.new
    
    add(Nimo::QuadRepresentation.for(Ball.new(pad, Wall.sections), :color => Gosu::red).always { move })
    add(Nimo::QuadRepresentation.for(pad, :color => Gosu::white).
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { move_up }.
      when_key(Gosu::Button::KbDown) { move_down })
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end


class Pad < Nimo::GameObject
  include Nimo::Behavior::Deflector
  include Nimo::Behavior::Moveable
  
  def initialize
    super(:x => 200, :y => 400, :width => 80, :height => 40, :speed => 5,
          :boundary => Object.from_hash(:x => 0, :y => 0, :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT))
  end
  
  def deflection_modifier(ball)
    (ball.center.x - self.center.x)/(1.5*@width)
  end
  
end


class Wall < Nimo::GameObject
  include Nimo::Behavior::Deflector
  
  def self.sections
    [ Wall.new(:x => -10, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10),
      Wall.new(:x => -10, :y => -10, :width => WINDOW_WIDTH + 10, :height => 10),
      Wall.new(:x => WINDOW_WIDTH, :y => -10, :width => 10, :height => WINDOW_HEIGHT + 10),
      Wall.new(:x => -10, :y => WINDOW_HEIGHT, :width => WINDOW_WIDTH, :height => 10) ]
  end
end


class Ball < Nimo::GameObject
  include Nimo::Behavior::Projectile
  
  def initialize(*deflectors)
    super(:x => 200, :y => 200, :width => 10, :height => 10, :velocity => Nimo::Behavior::Velocity.new(0.2, 0.7), :speed => 10)
    with_deflectors(deflectors)
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Bouncy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(GameScreen)
  window.show
end