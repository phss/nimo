module Nimo
  
  # Represents a game instance and provides access to the game screen and screen transition.
  # It is an extension of Gosu::Window, thus implementing the update, draw and button_down hooks.
  # 
  class GameWindow < Gosu::Window
    
    attr_reader :current_screen, :global_resources
    
    def initialize(name, width, height)
      super(width, height, false)
      self.caption = name
      
      @screens = {}
      @background_screens = []
      @global_resources = Nimo::Resources.new(self)
    end
    
    # Register a new screen with the <tt>name</tt>, using the supplied block as the Screen constructor.
    # 
    def screen(name, &blk)
      screen = Nimo::Screen.new(self, @global_resources)
      screen.instance_eval(&blk) if block_given?
      add_screen(name.to_s, screen)
    end

    # Load images that can be referenced by the tag.
    # Examples:
    #   image :some_tag => { :filename => "path_to_image.png" } # Load path_to_image.png to be used by the tag :some_tag
    #   image :tile_tag => { :filename => "path_to_tile.png", :tile_dimension => [32, 50] } # Load path_to_tile.png as a tile of width 32 and height 50
    # 
    def images(image_definitions)
      @global_resources.load_images(image_definitions)
    end

    # FIXME remove this method when done with the refactoring.
    def add_screens_by_class(*screen_classes) # :nodoc:
      screen_classes.each { |screen_class| add_screen(screen_class.to_s.sub("Screen", ""), screen_class.new(self, @global_resources)) }
    end
    
    def add_screen(name, screen)
      @screens[name] = screen
      go_to(name) if @screens.size == 1
    end
    
    # Switch to a Screen registered with the <tt>screen_name</tt>, notifying listeners of the :on_enter event. 
    #     
    def go_to(screen_name)
      raise "There is no screen named #{screen_name}" unless @screens.has_key? screen_name.to_s
      @current_screen = @screens[screen_name.to_s]
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