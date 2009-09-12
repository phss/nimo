# 
# imagey.rb
# 
# Demonstrate how to load and use whole images and sub-images as representations.
# The character and dungeon images were retrieved from: http://www.molotov.nu/?page=graphics
# 
# TODO Add better boundary check for trees
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'
include Gosu::Button

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480
WINDOW = {:x => 0, :y => 0, :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT}

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
    map_config = {:image => :map_tiles}
    representations = []
    
    16.times do |x|
      15.times do |y|
        if x == 0 || x == 15 || y == 0 || y == 14
          representations << map_config.merge(:x => x*32, :y => y*32, :index => 2)
        else
          representations << map_config.merge(:x => x*32, :y => y*32, :index => 79)
        end
      end
    end
    representations << map_config.merge(:x => 7*32, :y => 0, :index => 1)
    representations << map_config.merge(:x => 8*32, :y => 0, :index => 20)
    representations << map_config.merge(:x => 9*32, :y => 0, :index => 1)
    
    representations << map_config.merge(:x => 7*32, :y => 4*32, :index => 85)
    representations << map_config.merge(:x => 3*32, :y => 13*32, :index => 85)
    representations << map_config.merge(:x => 14*32, :y => 3*32, :index => 85)
    
    return representations
  end
end


if __FILE__ == $PROGRAM_NAME
  Nimo::Game("Imagey", WINDOW_WIDTH, WINDOW_HEIGHT) do
    images :jeeklabs => { :filename => "examples/images/jeeklabs.png" },
           :char_tiles => { :filename => "examples/images/dg_classm32.png", :tile_dimension => [32, 32] },
           :map_tiles => { :filename => "examples/images/dg_dungeon32.png", :tile_dimension => [32, 32] }
    
    screen :title do
      quad :with => WINDOW.merge(:color => Gosu::white)
      image :with => {:x => 116, :y => 190, :image => :jeeklabs}
      
      any_key { go_to :game }
    end
    
    screen :game do
      Dungeon.representation.each { |params| image :with => params }

      image :for => Player.new, :with => {:image => :char_tiles, :index => 85} do
        when_key(KbLeft, :repeatable => false) { self.move_left }
        when_key(KbRight, :repeatable => false) { self.move_right }
        when_key(KbUp, :repeatable => false) { move_up }
        when_key(KbDown, :repeatable => false) { move_down }
      end
        
      when_key(KbEscape) { exit }
    end
    
  end
  
end
