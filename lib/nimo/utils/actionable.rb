module Nimo
  
  # FIXME: finish it and rethink name
  module Actionable
    
    # Register an action that will execute when the key is pressed.
    # An options hash can be specified to customise the behavior. The options are:
    # - <tt>:repeatable</tt> (defaults to true) - execute the action every update regardless if the key was already pressed in the previous update.
    def when_key(key, options = {}, &action)
      key = @game_window.char_to_button_id(key) if key.class == String
      key_actions[key] = KeyAction.new(action, options)
      self
    end
    
    def update
      key_actions.each do |key, key_action|
        act_upon.instance_eval(&key_action.action) if key_action.should_execute?(@game_window.button_down?(key))
      end
    end
    
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