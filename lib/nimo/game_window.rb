module Nimo
  
  class GameWindow < Gosu::Window
    
    attr_reader :current_screen
    
    def initialize(name, width, height)
      super(width, height, false)
      self.caption = name
      
      @screens = {}
    end
    
    def add_screen(name, screen)
      @screens[name] = screen
      @current_screen = screen if @screens.size == 1
    end
    
    def add_screens_by_class(*screen_classes)
      screen_classes.each { |screen_class| add_screen(screen_class.to_s.sub("Screen", ""), screen_class.new(self)) }
    end
    
    def go_to(screen_name)
      raise "There is no screen named #{screen_name}" unless @screens.has_key? screen_name
      @current_screen = @screens[screen_name]
    end
  
    def update
      @current_screen.update
    end

    def draw
      @current_screen.draw
    end
  
    def button_down(id)
      @current_screen.button_down(id)
    end
    
  end
end