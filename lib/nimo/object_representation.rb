module Nimo
  
  # 
  # Nimo::GameObject's view. It holds actions to be executed on every update or when a key is pressed.
  # 
  class ObjectRepresentation
    include Actionable
    
    attr_reader :game_object
    attr_accessor :game_window

    def initialize(game_window, game_object)
      @game_window = game_window
      @game_object = game_object
      
      @always_actions = []
      @key_actions = {}
      @listener_actions = {}
    end

    # Hook to load data (i.e. images and fonts) from the game window. TODO not a great solution
    def load(resources, params)
    end

    # Register and action that always execute on a game update.
    def always(&action)
      @always_actions << action
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
      super
			@observer.call(self, game_object) unless @observer.nil?
    end

    # Should be overriden by childs
    def draw
    end

  end
  
end
