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

    # Register and action that always execute on a game update.
    def always(&action)
      @always_actions << action
      self
    end

    # Register an action that will execute when the key is pressed.
    # An options hash can be specified to customise the behavior. The options are:
    # - :repeatable (defaults to true) - execute the action every update regardless if the key was already pressed in the previous update.
    def when_key(key, options = {}, &action)
      key = @game_window.char_to_button_id(key) if key.class == String
      @key_actions[key] = KeyAction.new(action, options)
      self
    end
    
    # Register an action that will execute when the game object sends a notification.
    def listen_to(event_type, &action)
      @listener_actions[event_type] = action
      game_object.register_listener(event_type, self)
      self
    end
    
    def notify(event_type)
      @listener_actions[event_type].call(self, game_object) if @listener_actions.has_key? event_type
    end

		# Register an observer to be invoked every update, after all actions runned. This could be useful when a more complex behavior
		# is required from the representation, and there is a need to inspect the game object to change some state.
		def with_observer(&observer)
			@observer = observer
			self
		end

    def update
      @always_actions.each { |action| @game_object.instance_eval(&action) }
      @key_actions.each do |key, key_action|
        @game_object.instance_eval(&key_action.action) if key_action.should_execute?(@game_window.button_down?(key))
      end
			@observer.call(self, game_object) unless @observer.nil?
    end

    # Should be overriden by childs
    def draw
    end

  end
  
end

class KeyAction
  
  attr_reader :action
  
  def initialize(action, options)
    @action = action
    @options = {:repeatable => true}.merge(options)
    @pressed_since = nil
  end
  
  def should_execute?(is_button_down)
    should_execute = false
    if is_button_down
      should_execute = @pressed_since.nil? || @options[:repeatable]
      @pressed_since = Time.now if @pressed_since.nil?
    else
      @pressed_since = nil
    end
    return should_execute
  end
  
end
