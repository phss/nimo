# 
# soundy.rb
# 
# Demonstrate how to play sounds and background music. 
# 
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

class MainScreen < Nimo::Screen
  
	# TODO create a Sound (and Music?) representation	
  def representations
	  sound = Gosu::Sample.new(@game_window, "examples/sounds/KDE-Sys-Log-Out.ogg")
		sound.play
  end
  
  def button_down(id)
		exit
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Soundy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.add_screens_by_class(MainScreen)
  window.show
end
