module Nimo
  
  class ImageRepresentation < ObjectRepresentation
    represent :image
  
    def load(resources, params)
			raise "Must provide :image param for image loading" unless params.has_key?(:image)

      @image = resources.images[params[:image]]
      @image = @image[params[:index]] if params.has_key?(:index)
    end

    def draw
      @image.draw(@game_object.x, @game_object.y, 0)
    end
  end
  
end
