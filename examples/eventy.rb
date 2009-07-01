# 
# eventy.rb
# 
# Demonstrate how to use on enter and timer events. Not very detailed.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

WINDOW_WIDTH = 512
WINDOW_HEIGHT = 480

class MainScreen < Nimo::Screen
  
  def load
    @timer = Timer.new
    add(Nimo::TextRepresentation.at(:x => 10, :y => 200, :color => Gosu::white,
      :text => "Will exit in a few seconds"))
  end
  
  def on_enter
    @timer.start
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
