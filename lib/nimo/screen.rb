module Nimo
  
  class Screen
    
    def initialize(game_window)
      @game_window = game_window
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
    
    def add(representation)
      representation.game_window = @game_window
      representation.load
      @representations << representation
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