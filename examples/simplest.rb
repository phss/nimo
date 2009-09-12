# simplest.rb
# 
# Simplest example ever! A white box controlled by the arrow keys.
# 
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'
include Gosu::Button

Nimo::Game("Simplest", 640, 480) do
  
  screen :game do
    quad :with => { :width => 20, :height => 20, :color => Gosu::white } do
      when_key(KbLeft)  { self.x -= 5 }
      when_key(KbRight) { self.x += 5 }
      when_key(KbUp)    { self.y -= 5 }
      when_key(KbDown)  { self.y += 5 }
    end
    
    when_key(KbEscape) { exit }
  end
  
end