# 
# spritey.rb
# 
# Demonstrate how to create sprites and animations.
# 
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480
WINDOW = {:x => 0, :y => 0, :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT}

class TitleScreen < Nimo::Screen
  
  def representations
    add(Nimo::QuadRepresentation.at(WINDOW.merge(:color => Gosu::white)))
    add(Nimo::ImageRepresentation.at(:x => 116, :y => 190, :file => "examples/images/jeeklabs.png"))
  end
  
  def button_down(id)
    go_to(:Game)
  end
  
end

class GameScreen < Nimo::Screen
  
  def representations
    add(Nimo::QuadRepresentation.at(WINDOW.merge(:color => Gosu::white)))
    add(Nimo::SpriteRepresentation.for(Player.new, :file => "examples/images/tcheco.png").
      always { move }.
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { jump }.
      with_animation(:stopped, [0]).
      with_animation(:walking, [1, 2, 3, 4]).
      with_animation(:jumping, [5, 6, 7], :loop => false).
      with_animation(:falling, [8, 9], :loop => false).
      listen_to(:go_left) { |rep, obj| rep.flip }.
      listen_to(:go_right) { |rep, obj| rep.unflip })
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end

# TODO this is not a great implementation of a plataform character. Should think about creating a new behavior.
class Player < Nimo::GameObject
	include Nimo::Behavior::Moveable
 	#include Nimo::Behavior::Jumper

  def initialize
    super(:x => 0, :y => WINDOW_HEIGHT - 62, :width => 48, :height => 62, :speed => 5,
          :current_state => :stopped, :boundary => Object.from_hash(WINDOW))
    @y_velocity = 0
  end
  
  def move_left
		super()
    notify(:go_left)
    change_to(:walking) if @current_state == :stopped
  end
  
  def move_right
    super()
    notify(:go_right)
    change_to(:walking) if @current_state == :stopped
  end
  
  def move
    if y < @boundary.height - @height
      @y_velocity += 0.01
      change_to(:falling) if @y_velocity > 0
    else
      @y_velocity = 0
      change_to(:stopped)
    end
    
    @y += @speed * @y_velocity
   # change_to(:stopped) unless [:walking, :jumping, :falling].include?(@current_state)
  end
  
  def jump
    # Cannot jump twice
    if @y >= @boundary.height - @height
      @y_velocity = -1
      @y += @speed * @y_velocity
      change_to(:jumping)
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Spritey", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(TitleScreen, GameScreen)
  window.show
end
