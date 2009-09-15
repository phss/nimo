# Libraries
begin
  # In case you use Gosu via RubyGems.
  require "rubygems"
rescue LoadError
  # In case you don't.
end

require "gosu"

# NIMO_DIR = File.expand_path(File.dirname(__FILE__) + "/nimo")
NIMO_DIR = "nimo"

require NIMO_DIR + "/utils/object_extension"
require NIMO_DIR + "/utils/intersection"
require NIMO_DIR + "/utils/resources"
require NIMO_DIR + "/utils/game"

require NIMO_DIR + "/listeners/input_listener"
require NIMO_DIR + "/listeners/event_listener"

require NIMO_DIR + "/game_object"
require NIMO_DIR + "/game_window"
require NIMO_DIR + "/screen"

require NIMO_DIR + "/behavior/with_velocity"
require NIMO_DIR + "/behavior/deflector"
require NIMO_DIR + "/behavior/projectile"
require NIMO_DIR + "/behavior/moveable"

require NIMO_DIR + "/representations/object_representation"
require NIMO_DIR + "/representations/quad_representation"
require NIMO_DIR + "/representations/image_representation"
require NIMO_DIR + "/representations/text_representation"
require NIMO_DIR + "/representations/sprite_representation"
