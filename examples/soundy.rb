# 
# soundy.rb
# 
# Demonstrate how to play sounds and background music. 
# Copyright (sort of): the sounds used here came from my Ubuntu installation (probably from the KDE distribution).
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

class MainScreen < Nimo::Screen
  
	# TODO create a Sound (and Music?) representation	
  def representations
		sound(:startup).play
  end
  
  def button_down(id)
		exit
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Soundy", WINDOW_WIDTH, WINDOW_HEIGHT)
	window.load_sound(:startup, "examples/sounds/KDE-Sys-Log-Out.ogg")
  window.add_screens_by_class(MainScreen)
  window.show
end
