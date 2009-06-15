module Nimo
  
  class SpriteRepresentation < ObjectRepresentation
      attr_accessor :flip
    
      def initialize(game_window, game_object, params)
        super(game_window, game_object)
        @file = params[:file]
        
        @animations = {}
        @current_animation = nil
        unflip
      end

      def load
        @sprite_tiles = @game_window.resource_loader.load_image_tiles(@file, @game_object.width, @game_object.height)
      end
      
      def flip
        @drawing = lambda { |sprite| sprite.draw(@game_object.x + @game_object.width, @game_object.y, 0, -1) }
      end
      
      def unflip
        @drawing = lambda { |sprite| sprite.draw(@game_object.x, @game_object.y, 0) }
      end

      def draw
        if @current_animation.name != @game_object.current_state && @animations.has_key?(@game_object.current_state)
           @current_animation = @animations[@game_object.current_state]
           @current_animation.reset_animation
        end
        @drawing.call(@sprite_tiles[@current_animation.frame_index])
      end
      
      # Adds a new animation to the sprite. The first animation will be set as the current.
      # A list of options can be specified to customise the behavior:
      # - :timeout (default is 0.1): time to wait between frames
      # - :loop (default is true): true if the animation should start from the beginning, after the last element,
      #       otherwise it will draw the last frame
      def with_animation(name, frame_indexes, options = {})
        @animations[name] = Animation.new(name, frame_indexes, options)
        @current_animation = @animations[name] if @current_animation.nil?
        self
      end
    end
    
    class Animation
      attr_reader :name
      
      def initialize(name, frame_indexes, options)
        @name = name
        @frame_indexes = frame_indexes
        @options = {:timeout => 0.1, :loop => true}.merge(options)
        reset_animation
      end
      
      def reset_animation
        @current_index = 0
        @time_since_last_draw = Time.now
      end
      
      def frame_index
        if (Time.now - @time_since_last_draw) > @options[:timeout]
          @time_since_last_draw = Time.now
          @current_index += 1
          if @current_index == @frame_indexes.size
            @current_index = @options[:loop] ? 0 : @frame_indexes.size - 1
          end
        end
        @frame_indexes[@current_index]
      end
    end
end