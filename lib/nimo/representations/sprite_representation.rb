module Nimo
  
  class SpriteRepresentation < ObjectRepresentation
      def initialize(game_window, game_object, params)
        super(game_window, game_object)
        @file = params[:file]
      end

      def load
        @sprite_tiles = @game_window.resource_loader.load_image_tiles(@file, @game_object.width, @game_object.height)
      end

      def draw
        @sprite_tiles[0].draw(@game_object.x, @game_object.y, 0)
      end
      
      def with_animation(animation_name, image_indexes, is_loop = true)
        self
      end
    end  
end