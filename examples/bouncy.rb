# 
# bouncy.rb
# 
# Example using deflectors, projectiles and moveable behaviors. It demonstrates how to create interacting
# objects and representations
# 
# TODO: collision behavior is still a bit wonky. Balls disappear at the edge of the screen sometimes.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480


class GameScreen < Nimo::Screen
  
  def representations
    pad = Pad.new
    balls = (0..19).collect { Ball.new(pad, Wall.sections) }
    
    balls.each do |ball|
      ball.with_deflectors(balls.find_all { |other_ball| other_ball != ball })
      
      add(Nimo::QuadRepresentation.for(ball, :color => ball.color).
        always { move }.
        listen_to(:color_change) { |representation, object| representation.color = ball.color })
    end
      
    add(Nimo::QuadRepresentation.for(pad, :color => Gosu::white).
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { move_up }.
      when_key(Gosu::Button::KbDown) { move_down }.
      when_key(Gosu::Button::KbSpace) { balls.each { |ball| ball.speed,ball.old_speed = ball.old_speed,ball.speed }  })
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
    when_deflect { |projectile| projectile.change_color }
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
  include Nimo::Behavior::Deflector
  include Nimo::Behavior::Projectile
 
  attr_accessor :speed, :old_speed


  def initialize(*deflectors)
    random_velocity = Nimo::Behavior::Velocity.new(0, 1)
    random_velocity.adjust(rand + -rand)
    
    super(:x => 200, :y => 200, :width => 10, :height => 10, :velocity => random_velocity, :speed => 10, :old_speed => 0)
    with_deflectors(deflectors)
    
    @colors = [Gosu::red, Gosu::green, Gosu::yellow, Gosu::blue, Gosu::white]
    @color_index = 0
  end
  
  def color
    @colors[@color_index]
  end
  
  def change_color
    @color_index = @color_index == @colors.size - 1 ? 0 : @color_index + 1
    notify(:color_change)
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Bouncy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(GameScreen)
  window.show
end
