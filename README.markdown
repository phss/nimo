:warning: Not really active or maintained. But still has some fun bits of code. :warning:

# Nimo: Yet another Ruby game library/framework/thingie

Nimo is yet another Ruby game thing. It is based on Gosu (http://www.libgosu.org). I can't claim this is the best way of doing a game library, but at least it is my try. I had a lot of fun implementing this and hopefully will use it in a few fun games.

What I am aiming is to define a clear separation between the game object's behavior (or domain behavior) from how to represent the object. Theoretically this would allows the creation of a game logic completely separated from the details of sprite rendering and pooling for inputs and whatnot.

## Installing

You can install the gem through the github:

	gem sources -a http://gems.github.com
	sudo gem install moonpxi-nimo

## Example

This example (from examples/simplest.rb) allows you to control a white square on a black background (very fancy). It gives you a flavor of how to setup a screen and a very simple game object with input control.

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

## More info

To learn more about Nimo, I suggest an inspection of the examples, specs and rdocs. 

The examples, with silly names, are:

	* bouncy.rb: how to create game objects with behavior and simple quad representations
	* screeny.rb: how to navigate between screens and menus with text representations
	* imagey.rb: how to load images as representations
  * spirtey.rb: how to create a sprite representation
  * soundy.rb: how to play sounds
  * eventy.rb: how to create timer events

Hopefuly the specs and rdocs are comprehensive enough. If all else fails, send me a message.
