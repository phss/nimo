module Nimo
  
  class Screen
    
    def initialize(game_window)
      @game_window = game_window
      @representations = initialize_representations
    end
    
    # To be overriden by childs
    def initialize_representations
      []
    end
  
    def update
      @representations.each { |representation| representation.update }
    end
  
    def draw
      @representations.each { |representation| representation.draw }
    end
    
    def remove_representation_for(object)
      @representations.delete_if { |representation| representation.game_object == object }
    end
  
    def button_down(id)
      # Do nothing
    end
  
  end
  
end