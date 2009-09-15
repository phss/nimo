module Nimo
  
  # Helper method to create and show a new GameWindow with a construction block.
  # 
  # Example, from simplest.rb:
  # 
  #   Nimo::Game("Simplest", 640, 480) do
  #     screen :game do
  #       quad :with => { :width => 20, :height => 20, :color => Gosu::white } do
  #         # Code ommited.
  #       end
  #       when_key(Gosu::Button::KbEscape) { exit }
  #     end
  #   end
  #   
  def self.Game(title, width, height, &blk)
    window = Nimo::GameWindow.new(title, width, height)
    GameBuilder.new(window).instance_eval(&blk) if block_given?
    window.show
    return window
  end
  
  class GameBuilder
    def initialize(game_window)
      @game_window = game_window
      @resources = Nimo::Resources.new(@game_window)
    end

    # Load images that can be referenced by a tag.
    # Example of <tt>image_definitions</tt>:
    #   images :some_tag => { :filename => "path_to_image.png" } # Load path_to_image.png to be used by the tag :some_tag
    #   images :tile_tag => { :filename => "path_to_tile.png", :tile_dimension => [32, 50] } # Load path_to_tile.png as a tile of width 32 and height 50
    # 
    def images(image_definitions)
      @resources.load_images(image_definitions)
    end
    
    # Load fonts that can be referenced by a tag.
    # Example of <tt>font_definitions</tt>:
    #   fonts :some_tag => { :type => "font_type", :size => 20 } # Load font of type 'font_type'
    #
    def fonts(font_definitions)
      @resources.load_fonts(font_definitions)
    end
    
    # Load sounds that can be referenced by a tag.
    # Example of <tt>sound_definitions</tt>:
    #   sounds :some_tag => { :filename => "some_file.wav", :size => 20 }
    #
    def sounds(sound_definitions)
      @resources.load_sounds(sound_definitions)
    end
    
    # Register a new screen with the <tt>name</tt>, using the supplied block as the Screen constructor.
    # 
    def screen(screen_id, &blk)
      screen = Nimo::Screen.new(screen_id, @game_window, @resources)
      screen.instance_eval(&blk) if block_given?
      @game_window.add_screen(screen_id, screen)
    end
  end
  
end