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
  
  def load    
    self.when(:on_enter) { @resources.sounds[:startup].play(true) }
    
    add(Nimo::TextRepresentation, :with => {:x => 10, :y => 10, :font => :main, :color => Gosu::white,
      :text => "This screen will play a background sound."})
    add(Nimo::TextRepresentation, :with => {:x => 10, :y => 28, :font => :main, :color => Gosu::white,
      :text => "Press <esc> to quit or any other key to go to the next screen."})      
  end
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      exit 
    else
      @resources.sounds[:startup].stop
      go_to(:Another)
    end
  end
  
end

class AnotherScreen < Nimo::Screen
  
  def load
    add(Nimo::TextRepresentation, :with => {:x => 10, :y => 10, :font => :main, :color => Gosu::white,
      :text => "This screen will play a sound effect."})
    add(Nimo::TextRepresentation, :with => {:x => 10, :y => 28, :font => :main, :color => Gosu::white,
      :text => "Press <esc> to go back or any other key to play the sound."})
  end
  
  def button_down(id)
    go_to(:Main) if id == Gosu::Button::KbEscape
    @resources.sounds[:effect].play
  end
  
end


if __FILE__ == $PROGRAM_NAME
  window = Nimo::GameWindow.new("Soundy", WINDOW_WIDTH, WINDOW_HEIGHT)
  window.global_resources.
    with_sound(:startup, "examples/sounds/KDE-Sys-Log-Out.ogg").
    with_sound(:effect, "examples/sounds/k3b_error1.wav").    
    with_font(:main, "Helvetica", 15)
  window.add_screens_by_class(MainScreen, AnotherScreen)
  window.show
end
