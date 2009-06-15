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
      always { move; stop; gravity }.
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { jump }.
      with_animation(:stopped, [0]).
      with_animation(:walking, [1, 2, 3, 4]).
      with_animation(:jumping, [5, 6, 7], false).
      with_animation(:falling, [8, 9], false))
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end

# TODO this is not a great implementation of a plataform character. Should think about creating a new behavior.
class Player < Nimo::GameObject
  include Nimo::Behavior::Projectile
  
  def initialize
    super(:x => 0, :y => WINDOW_HEIGHT - 62, :width => 48, :height => 62, :speed => 5)
  end
  
  def move_left
    @velocity.x = -1
    notify(:walk)
  end
  
  def move_right
    @velocity.x = 1
    notify(:walk)
  end
  
  def stop
    @velocity.x = 0
  end
  
  def gravity
    if y < WINDOW_HEIGHT - 62
      @velocity.y += 0.01
    else
      @velocity.y = 0
      @y = WINDOW_HEIGHT - 62
    end
  end
  
  def jump
    # Cannot jump twice
    if y >= WINDOW_HEIGHT - 62
      @velocity.y = -1
      notify(:jump)
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Spritey", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(TitleScreen, GameScreen)
  window.show
end
