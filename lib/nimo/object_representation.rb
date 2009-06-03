module Nimo
  
  class ObjectRepresentation
    
    attr_reader :game_object

    def initialize(game_window, game_object)
      @game_window = game_window
      @game_object = game_object
      @always_actions = []
      @key_actions = {}
    end

    def always(&action)
      @always_actions << action
    end

    def when_key(key, &action)
      key = @game_window.char_to_button_id(key) if key.class == String
      @key_actions[key] = action
    end

    def update
      @always_actions.each { |action| @game_object.instance_eval(&action) }
      @key_actions.each { |key, action| @game_object.instance_eval(&action) if @game_window.button_down?(key) }
    end

    # Should be overriden by childs
    def draw
    end

  end
  
end