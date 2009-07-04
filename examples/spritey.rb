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
  
  def load
    add(Nimo::QuadRepresentation, :with => WINDOW.merge(:color => Gosu::white))
    add(Nimo::ImageRepresentation, :with => {:x => 116, :y => 190, :image => :jeeklabs})
  end
  
  def button_down(id)
    go_to(:Game)
  end
  
end

class GameScreen < Nimo::Screen
  
  def load
		player_observer = Proc.new do |rep, obj|
		  rep.flip if obj.velocity.x < 0
		  rep.unflip if obj.velocity.x > 0	

			rep.change_to(:stopped) if obj.velocity.x == 0
			rep.change_to(:walking) if obj.velocity.x != 0
			rep.change_to(:jumping) if obj.velocity.y < 0
			rep.change_to(:falling) if obj.velocity.y > 0
		end

    add(Nimo::QuadRepresentation, :with => WINDOW.merge(:color => Gosu::white))
    add(Nimo::SpriteRepresentation, :for => Player.new, :with => {:image => :tcheco}).
      always { move }.
      when_key(Gosu::Button::KbLeft) { move_left }.
      when_key(Gosu::Button::KbRight) { move_right }.
      when_key(Gosu::Button::KbUp) { jump }.
      with_animation(:stopped, [0]).
      with_animation(:walking, [1, 2, 3, 4]).
      with_animation(:jumping, [5, 6, 7], :loop => false).
      with_animation(:falling, [8, 9], :loop => false).
			with_observer(&player_observer)
  end
  
  def button_down(id)
    exit if id == Gosu::Button::KbEscape
  end
  
end

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
  window = Nimo::GameWindow.new("Spritey", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.global_resources.
    with_image(:jeeklabs, "examples/images/jeeklabs.png").
    with_image_tiles(:tcheco, "examples/images/tcheco.png", 48, 62)
  
  window.add_screens_by_class(TitleScreen, GameScreen)
  window.show
end
