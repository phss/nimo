module Nimo
  
  # 
  # Nimo::GameObject's view. It holds actions to be executed on every update or when a key is pressed.
  # 
  class ObjectRepresentation
    
    attr_reader :game_object
    attr_accessor :game_window

    def initialize(game_window, game_object, params = {})
      @game_window = game_window
      @game_object = game_object
      @always_actions = []
      @key_actions = {}
      @listener_actions = {}
    end
    
    def self.for(game_object, params = {})
      self.new(nil, game_object, params)
    end
    
    def self.at(params = {})
      self.for(Nimo::GameObject.new(params), params)
    end
    
    # Hook to load data (i.e. images and fonts) from the game window. TODO not a great solution
    def load
    end

    # Always execute the action on a game update
    def always(&action)
      @always_actions << action
      self
    end

    # Execute the action when the key is pressed
    def when_key(key, &action)
      key = @game_window.char_to_button_id(key) if key.class == String
      @key_actions[key] = action
      self
    end
    
    # Execute the action when the game object sends a notification
    def listen_to(event_type, &action)
      @listener_actions[event_type] = action
      game_object.register_listener(event_type, self)
      self
    end
    
    def notify(event_type)
      @listener_actions[event_type].call(self, game_object) if @listener_actions.has_key? event_type
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