module Nimo
  
  # Represents a game instance and provides access to the game screen and screen transition.
  # It is an extension of Gosu::Window, thus implementing the update, draw and button_down hooks.
  #
  class GameWindow < Gosu::Window
    
    attr_reader :current_screen
    
    def initialize(name, width, height)
      super(width, height, false)
      self.caption = name
      
      @screens = {}
      @background_screens = []
    end
    
    def add_screen(name, screen)
      @screens[name] = screen
      go_to(name) if @screens.size == 1
    end
    
    # Switch to a Screen registered with the <tt>screen_name</tt>, notifying listeners of the :on_enter event. 
    #     
    def go_to(screen_name)
      raise "There is no screen named #{screen_name}" unless @screens.has_key? screen_name
      @current_screen = @screens[screen_name]
      @current_screen.notify(:on_enter)
    end

    # Open a Screen registered with the <tt>screen_name</tt> as a menu. To dismiss the menu, use close_menu.
    #
    def open_menu(screen_name)
      @background_screens << @current_screen
      go_to(screen_name)
    end
    
    def close_menu
      @current_screen = @background_screens.pop
    end
    
    # :section: Gosu::Window hooks
    
    def update
     @current_screen.update
    end

    def draw
      @background_screens.each { |screen| screen.draw }
      @current_screen.draw
    end
  
    def button_down(id)
      @current_screen.button_down(id)
    end
    
  end

end
