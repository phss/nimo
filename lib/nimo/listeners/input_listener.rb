module Nimo
  
  # Listen for inputs (key presses) and execute the corresponding actions on update.
  # 
  module InputListener
    
    # Register an action that will execute when the key is pressed.
    # An options hash can be specified to customise the behavior. The options are:
    # - <tt>:repeatable</tt> (defaults to true) - execute the action every update regardless if the key was already pressed in the previous update.
    # 
    def when_key(key, options = {}, &action)
      key_actions[key] = KeyAction.new(action, options)
    end
    
    # Register an action to be executed everytime a key is pressed.
    # 
    def any_key(&action)
      @any_key_action = action
    end
    
    # Gosu hook invoked anytime a button is pressed
    # 
    def button_down(id) #:nodoc:
       act_upon.instance_eval(&@any_key_action) if @any_key_action
    end
    
    def process_inputs(game_window)
      key_actions.each do |key, key_action|
        act_upon.instance_eval(&key_action.action) if key_action.should_execute?(game_window.button_down?(key))
      end
    end
    
    protected
    
    # Defines the object to be the context of the action. By default it is <tt>self</tt>.
    # 
    def act_upon
      self
    end
    
    private
    
    def key_actions
      @key_actions ||= {}
    end
    
    
    class KeyAction
      attr_reader :action

      def initialize(action, options)
        @action = action
        @options = {:repeatable => true}.merge(options)
        @pressed_since = nil
      end

      def should_execute?(is_button_down)
        should_execute = false
        if is_button_down
          should_execute = @pressed_since.nil? || @options[:repeatable]
          @pressed_since = Time.now if @pressed_since.nil?
        else
          @pressed_since = nil
        end
        return should_execute
      end

    end
  end
end