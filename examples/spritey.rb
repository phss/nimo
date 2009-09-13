# 
# spritey.rb
# 
# Demonstrate how to create sprites and animations.
# 
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'
include Gosu::Button

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480
WINDOW = {:x => 0, :y => 0, :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT}

class Player < Nimo::GameObject
	include Nimo::Behavior::WithVelocity

  def initialize
    super(:x => 0, :y => WINDOW_HEIGHT - 62, :width => 48, :height => 62, :speed => 5, :boundary => Object.from_hash(WINDOW))
  end
  
  def move_left
		@velocity.x = -1	  
  end
  
  def move_right
		@velocity.x = 1
  end
  
  def move
		super
    if y < @boundary.height - @height
      @velocity.y += 0.01
    else
      @velocity.y = 0
    end
  
	  @velocity.x = 0	
  end
  
  def jump
    # Cannot jump twice
    if @y >= @boundary.height - @height
      @velocity.y = -1
      @y += @speed * @velocity.y
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  Nimo::Game("Spritey", WINDOW_WIDTH, WINDOW_HEIGHT) do
    images :jeeklabs => { :filename => "examples/images/jeeklabs.png" },
           :tcheco => { :filename => "examples/images/tcheco.png", :tile_dimension => [48, 62] }
           
    screen :title do
      quad :with => WINDOW.merge(:color => Gosu::white)
      image :with => {:x => 116, :y => 190, :image => :jeeklabs}
      
      any_key { go_to :game }
    end
    
    screen :game do
      player_observer = Proc.new do |rep, obj|
  		  rep.flip if obj.velocity.x < 0
  		  rep.unflip if obj.velocity.x > 0	

  			rep.change_to(:stopped) if obj.velocity.x == 0
  			rep.change_to(:walking) if obj.velocity.x != 0
  			rep.change_to(:jumping) if obj.velocity.y < 0
  			rep.change_to(:falling) if obj.velocity.y > 0
  		end

      quad :with => WINDOW.merge(:color => Gosu::white)
      sprite :for => Player.new, :with => {:image => :tcheco} do
        always { move }
        when_key(KbLeft) { move_left }
        when_key(KbRight) { move_right }
        when_key(KbUp) { jump }
        with_animation(:stopped, [0])
        with_animation(:walking, [1, 2, 3, 4])
        with_animation(:jumping, [5, 6, 7], :loop => false)
        with_animation(:falling, [8, 9], :loop => false)
  			with_observer(&player_observer)
			end
  			
  		when_key(KbEscape) { exit }
    end
  end
end