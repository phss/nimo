module Nimo
  
  #
  # Base game domain object containing position, dimension and state information. Any object that represents
  # a game entity should extend this class.
  # 
  # The position (:x and :y) and dimension (:width and :height) are used for visual representations and any 
  # useful game behavior. The state (:current_state) is mostly optional, being used for Nimo::SpriteRepresentation
  # to know what animation to draw. It can also be handy or complex behavior.
  #
  class GameObject
    attr_accessor :x, :y, :width, :height, :current_state
      
    def initialize(config_options = {})
      configure_with({:x => 0, :y => 0, :width => 0, :height => 0}.merge(config_options))
      @listeners = {}
    end
  
    def at(x, y)
      @x = x
      @y = y
    end
  
    def dimension(width, height)
      @width = width
      @height = height
    end
    
    # config_options is a hash that can take the following keys: :x, :y, :width, :height. 
    # The key restriction is not being enforced.
    def configure_with(config_options)
      config_options.each { |attribute, value| instance_variable_set("@#{attribute}", value) }
    end
  
    def collide?(obj)
      !(obj.x > (@x + @width)  || @x > (obj.x + obj.width) ||
        obj.y > (@y + @height) || @y > (obj.y + obj.height))
    end
    
    def intersection(obj)
      collide?(obj) ? Intersection.between(self, obj) : nil
    end

    def center
      Object.from_hash(:x => @x + (@width/2), :y => @y + (@height/2))
    end
    
    def register_listener(event_type, listener)
      @listeners[event_type] ||= []
      @listeners[event_type] << listener
    end
    
    def notify(event_type)
      @listeners[event_type].each { |listener| listener.notify(event_type) } if @listeners.has_key? event_type
    end

    def change_to(state)
      @current_state = @current_state.is_a?(Hash) ? @current_state.merge(state) : state
    end
    
  end
  
end
