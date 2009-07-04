module Nimo
  
  class Screen
    
    def initialize(game_window, resources)
      @game_window = game_window
      @resources = resources
      
      @representations = []
      @events = {}
      
      load
    end
    
    # To be overriden by childs for loading resources and adding representations.
    def load
    end
  
    def update
      @representations.each { |representation| representation.update }
    end
  
    def draw
      @representations.each { |representation| representation.draw }
    end
    
    # Add a representation to the screen. The options params is used to specify a GameObject and params. It returns the 
    # constructed representation.
    # Examples of usage:
    # - screen.add(SomeRepresentation, :for => object, :with => { :attr => "something"}) will construct SomeRepresentation with the supplied object and :with params
    # - screen.add(SomeRepresentation, :with => { :attr => "something"}) will construct SomeRepresentation with a vanilla Nimo::GameObject
    def add(representation_class, options)
      params = options.has_key?(:with) ? options[:with] : {}
      game_object = options.has_key?(:for) ? options[:for] : Nimo::GameObject.new(params)
      
      representation = representation_class.new(@game_window, game_object)
      representation.load(@resources, params)
      
      @representations << representation
      representation
    end
    
    def remove_representation_for(object)
      @representations.delete_if { |representation| representation.game_object == object }
    end
    
    # Register an action to be executed when an event is notified. The Nimo events are: 
    # - :on_enter when a screen is 'entered'. TODO need to think of a better term.
    def when(event, &action)
      @events[event] = action
    end
    
    def notify(event)
      @events[event].call if @events.has_key?(event)
    end
  
    def button_down(id)
      # Do nothing
    end
    
    # Proxy methods to Nimo::GameWindow.
    def method_missing(meth, *args, &blk)
      @game_window.send(meth, *args, &blk)
    end
  
  end
  
end