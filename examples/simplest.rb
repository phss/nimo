# simplest.rb
# 
# Simplest example ever! A white box controlled with the arrow keys.
# 
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'nimo'

Nimo::Game("Simplest", 640, 480) do
  
  screen :game do
    quad :with => { :width => 20, :height => 20, :color => Gosu::white } do
      when_key(Gosu::Button::KbLeft)  { x -= 5 }
      when_key(Gosu::Button::KbRight) { x += 5 }
      when_key(Gosu::Button::KbUp)    { y -= 5 }
      when_key(Gosu::Button::KbDown)  { y += 5 }
    end
    
    when_key(Gosu::Button::KbEscape) { exit }
  end
  
end