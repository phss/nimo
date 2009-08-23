require "forwardable"

module Nimo
  
  # Represent a game's screen, holding representations of domain objects for updates and draws.
  # 
  class Screen
    extend Forwardable
    
    def_delegators :@game_window, :go_to, :open_menu, :close_menu
    
    def initialize(game_window, resources)
      @game_window = game_window
      @resources = resources
      
      @representations = []
      @events = {}
    end
    
    # Add a representation to the screen. The options params is used to specify a GameObject and params. It returns the 
    # constructed representation.
    # Examples of usage:
    #   screen.add(SomeRepresentation, :for => object, :with => { :attr => "something"}) # will construct SomeRepresentation with the supplied object and :with params
    #   screen.add(SomeRepresentation, :with => { :attr => "something"}) # will construct SomeRepresentation with a vanilla Nimo::GameObject
    # 
    def add(representation_class, options)
      params = options.has_key?(:with) ? options[:with] : {}
      game_object = options.has_key?(:for) ? options[:for] : Nimo::GameObject.new(params)
      
      representation = representation_class.new(@game_window, game_object)
      representation.load(@resources, params)
      
      @representations << representation
      representation
    end
    
    # Updates all representations.
    # 
    def update
      @representations.each { |representation| representation.update }
    end
  
    # Draws all representations.
    # 
    def draw
      @representations.each { |representation| representation.draw }
    end
    
    # Register an action to be executed when an event is notified. The Nimo events are: 
    # - <tt>:on_enter</tt> when a screen is 'entered'. TODO need to think of a better term.
    # 
    def when(event, &action)
      @events[event] = action
    end
    
    # Execute registered action for notified event
    # 
    def notify(event)
      @events[event].call if @events.has_key?(event)
    end
  
  end
  
end