module Nimo
  
  class Screen
    
    def initialize(game_window)
      @game_window = game_window
      @obj_representations = []
      representations
    end
    
    # To be overriden by childs
    def representations
    end
  
    def update
      @obj_representations.each { |representation| representation.update }
    end
  
    def draw
      @obj_representations.each { |representation| representation.draw }
    end
    
    def add(representation)
      representation.game_window = @game_window
      representation.load
      @obj_representations << representation
    end
    
    def remove_representation_for(object)
      @obj_representations.delete_if { |representation| representation.game_object == object }
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