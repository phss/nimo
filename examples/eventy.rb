# 
# eventy.rb
# 
# Demonstrate how to use on enter and timer events. Not very detailed.
#
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

TEN_SECONDS = 10*60*1000 # ???

Nimo::Game("Eventy", 512, 480) do
  screen :main do
    text :with => { :text => "Will exit in a few seconds", :x => 10, :y => 200, :color => Gosu::white }
    
    listen_to(:on_enter) { timer_for(TEN_SECONDS) { exit } }
    any_key { exit }
  end
end