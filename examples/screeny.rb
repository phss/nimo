# 
# screeny.rb
# 
# Example demonstrates how to navigate between screens and menus, and also some text output.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'
include Gosu::Button

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

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
  Nimo::Game("Screeny", WINDOW_WIDTH, WINDOW_HEIGHT) do
    fonts :main => { :type => "Helvetica", :size => 20 }
    
    screen :start do
      text :with => {:text => "StartScreen: press any key to go to the GameScreen", 
                     :x => 10, :y => 200, :font => :main, :color => Gosu::white}
      any_key { go_to :game }
    end
    
    screen :game do
      text :with => {:text => "GameScreen: press any key to open the MenuScreen",
                     :x => 10, :y => 10, :font => :main, :color => Gosu::white}

      balls = (0..19).collect { Ball.new(Wall.sections) }
      balls.each do |ball|
        ball.with_deflectors(balls.find_all { |other_ball| other_ball != ball })
        quad :for => ball, :with => {:color => Gosu::red} do
          always { move }
        end
      end
      
      any_key { open_menu :menu }
    end
    
    screen :menu do
      text :with => {:text => "MenuScreen:", :x => 100, :y => 200, :font => :main, :color => Gosu::white, :size => 15}
      text :with => {:text => "- <ESC> to go to the EndScreen", :x => 100, :y => 215, :font => :main, :color => Gosu::white, :size => 15}
      text :with => {:text => "- <ENTER> to go to the GameScreen", :x => 100, :y => 230, :font => :main, :color => Gosu::white, :size => 15}
      
      when_key(KbReturn) { close_menu }
      when_key(KbEscape) { close_menu and go_to :end }
    end
    
    screen :end do
      text :with => {:text => "EndScreen: you've reached the end of this example!",
                     :x => 10, :y => 200, :font => :main, :color => Gosu::white}
      any_key { exit }
    end
  end
end