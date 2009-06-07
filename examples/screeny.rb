# 
# screeny.rb
# 
# Example demonstrates how to navigate between screens and menus, and also some text output.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480


class StartScreen < Nimo::Screen
  def button_down(id)
    go_to(:Game) if id == Gosu::Button::KbEscape
  end
end


class GameScreen < Nimo::Screen
  def representations
    balls = (0..19).collect { Ball.new(Wall.sections) }
    balls.each do |ball|
      ball.with_deflectors(balls.find_all { |other_ball| other_ball != ball })
      add(Nimo::QuadRepresentation.for(ball, :color => Gosu::red).always { move })
    end
  end
  
  def button_down(id)
     go_to(:Menu) if id == Gosu::Button::KbEscape
  end
end


class MenuScreen < Nimo::Screen
  def button_down(id)
    go_to(:End) if id == Gosu::Button::KbEscape
  end
end


class EndScreen < Nimo::Screen
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
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
  include Nimo::Behavior::Deflector
  include Nimo::Behavior::Projectile
  
  def initialize(*deflectors)
    random_velocity = Nimo::Behavior::Velocity.new(0, 1)
    random_velocity.adjust(rand + -rand)
    
    super(:x => 200, :y => 200, :width => 10, :height => 10, :velocity => random_velocity, :speed => 10)
    with_deflectors(deflectors)
  end
  
end

if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Screeny", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(StartScreen, GameScreen, MenuScreen, EndScreen)
  window.show
end