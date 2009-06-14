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
    Dungeon.representation.each { |block| add(block) }
    add(Nimo::ImageRepresentation.for(Player.new, :file => "examples/images/dg_classm32.png", :index => 85).
      when_key(Gosu::Button::KbLeft, :repeatable => false) { move_left }.
      when_key(Gosu::Button::KbRight, :repeatable => false) { move_right }.
      when_key(Gosu::Button::KbUp, :repeatable => false) { move_up }.
      when_key(Gosu::Button::KbDown, :repeatable => false) { move_down })
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end

class Player < Nimo::GameObject
  include Nimo::Behavior::Moveable
  
  def initialize
    super(:x => 32, :y => 32, :width => 32, :height => 32, :speed => 32, 
          :boundary => Object.from_hash(:x => 32, :y => 32, :width => WINDOW_WIDTH - 32, :height => WINDOW_HEIGHT - 32))
  end
end

class Dungeon
  # A bit hacktastic!
  def self.representation
    map_file = "examples/images/dg_dungeon32.png"
    map_config = {:width => 32, :height => 32, :file => map_file}
    representations = []
    
    16.times do |x|
      15.times do |y|
        if x == 0 || x == 15 || y == 0 || y == 14
          representations << Nimo::ImageRepresentation.at(map_config.merge(:x => x*32, :y => y*32, :index => 2))
        else
          representations << Nimo::ImageRepresentation.at(map_config.merge(:x => x*32, :y => y*32, :index => 79))
        end
      end
    end
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 7*32, :y => 0, :index => 1))
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 8*32, :y => 0, :index => 20))
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 9*32, :y => 0, :index => 1))
    
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 7*32, :y => 4*32, :index => 85))
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 3*32, :y => 13*32, :index => 85))
    representations << Nimo::ImageRepresentation.at(map_config.merge(:x => 14*32, :y => 3*32, :index => 85))
    
    return representations
  end
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Imagey", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(TitleScreen, GameScreen)
  window.show
end