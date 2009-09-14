module Nimo
  
  # 
  # Nimo::GameObject's view. It holds actions to be executed on every update or when a key is pressed.
  # 
  class ObjectRepresentation
    include InputListener, EventListener
    
    attr_reader :game_object
    attr_accessor :game_window

    def initialize(game_window, game_object)
      @game_window = game_window
      @game_object = game_object
      
      @always_actions = []
    end

    # Hook to load data (i.e. images and fonts) from the game window. FIXME: not a great solution
    def load(resources, params)
    end

    # Register and action that always execute on a game update.
    def always(&action)
      @always_actions << action
      self
    end
    
    # Register an action that will execute when the game object sends a notification. Overrides EventListener to 
    # add default registration to game_object.
    # 
    def listen_to(event_type, &action)
      super
      game_object.register_listener(event_type, self)
    end

		# Register an observer to be invoked every update, after all actions runned. This could be useful when a more complex behavior
		# is required from the representation, and there is a need to inspect the game object to change some state.
		def with_observer(&observer)
			@observer = observer
		end

    def update
      @always_actions.each { |action| @game_object.instance_eval(&action) }
      process_inputs
			@observer.call(self, game_object) unless @observer.nil?
    end

    # Should be overriden by childs
    def draw
    end

    def act_upon
      @game_object
    end
    
    private

    # Register itself as a object representation with the shortcut name.
    # 
    def self.represent(representation_name)
      Screen.register_representation(representation_name, self)
    end

  end
  
end
