# 
# imagey.rb
# 
# Demonstrate how to load and use whole images and sub-images as representations.
# The character and dungeon images were retrieved from: http://www.molotov.nu/?page=graphics
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
    add(Nimo::ImageRepresentation.for(Player.new, :file => "examples/images/dg_classm32.png", :index => 21).
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { move_up }.
      when_key(Gosu::Button::KbDown) { move_down })
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end

class Player < Nimo::GameObject
  include Nimo::Behavior::Moveable
  
  def initialize
    super(:x => 0, :y => 0, :width => 32, :height => 32, :speed => 32, :boundary => Object.from_hash(WINDOW))
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Imagey", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(TitleScreen, GameScreen)
  window.show
end