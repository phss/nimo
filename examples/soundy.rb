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

Nimo::Game("Soundy", WINDOW_WIDTH, WINDOW_HEIGHT) do
  sounds :startup => { :filename => "examples/sounds/KDE-Sys-Log-Out.ogg" },
         :effect => { :filename => "examples/sounds/k3b_error1.wav" }
  fonts :main => { :type => "Helvetica", :size => 15}
  
  screen :main do
    # FIXME: refactor event listening
    self.when(:on_enter) { @resources.sounds[:startup].play(true) }

    text :with => {:x => 10, :y => 10, :font => :main, :color => Gosu::white,
                   :text => "This screen will play a background sound."}
    text :with => {:x => 10, :y => 28, :font => :main, :color => Gosu::white,
                   :text => "Press <esc> to quit or <enter> to go to the next screen."}
    
    when_key(Gosu::Button::KbEscape) { exit }
    when_key(Gosu::Button::KbReturn) do
      # FIXME: rethink how to use resources
      @resources.sounds[:startup].stop
      go_to :another
    end
  end
  
  screen :another do
    text :with => {:x => 10, :y => 10, :font => :main, :color => Gosu::white,
                   :text => "This screen will play a sound effect."}
    text :with => {:x => 10, :y => 28, :font => :main, :color => Gosu::white,
                   :text => "Press <esc> to go back or <enter> to play the sound."}

    when_key(Gosu::Button::KbEscape) { go_to :main }
    when_key(Gosu::Button::KbReturn) { @resources.sounds[:effect].play }
  end
end