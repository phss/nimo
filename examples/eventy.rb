# 
# eventy.rb
# 
# Demonstrate how to use on enter and timer events. Not very detailed.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

THREE_SECONDS = 3

Nimo::Game("Eventy", 512, 480) do
  fonts :main => { :type => "Helvetica", :size => 20 }

  screen :main do
    text :with => { :text => "Will exit in a three seconds", :font => :main, :x => 10, :y => 200, :color => Gosu::white }
    listen_to(:on_enter) { @game_window.timer_for(THREE_SECONDS) { exit } } # FIXME: not use game_window
  end
end