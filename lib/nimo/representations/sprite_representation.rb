module Nimo
  
  class SpriteRepresentation < ObjectRepresentation
      def initialize(game_window, game_object, params)
        super(game_window, game_object)
        @file = params[:file]
        
        @animations = {}
        @current_animation = nil
      end

      def load
        @sprite_tiles = @game_window.resource_loader.load_image_tiles(@file, @game_object.width, @game_object.height)
      end

      def draw
        if @current_animation.name.to_s != @game_object.current_state.to_s && @animations.has_key?(@game_object.current_state.to_s)
           @current_animation = @animations[@game_object.current_state.to_s]
           @current_animation.reset_animation
        end
        if @current_animation.flip?
          @sprite_tiles[@current_animation.frame_index].draw(@game_object.x + @game_object.width, @game_object.y, 0, -1)
        else
          @sprite_tiles[@current_animation.frame_index].draw(@game_object.x, @game_object.y, 0)
        end
      end
      
      # List options.
      def with_animation(name, frame_indexes, options = {})
        @animations[name.to_s] = Animation.new(name, frame_indexes, options)
        @current_animation = @animations[name.to_s] if @current_animation.nil?
        self
      end
    end
    
    class Animation
      attr_reader :name
      
      def initialize(name, frame_indexes, options)
        @name = name
        @frame_indexes = frame_indexes
        @options = {:timeout => 0.1, :loop => true, :flipped => false}.merge(options)
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
      
      def flip?
        @options[:flipped]
      end
    end
end