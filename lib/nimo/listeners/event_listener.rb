module Nimo
  
  # Listen for events and execute for actions on notification.
  # 
  module EventListener
    
    # Register an action to be executed when an event is notified.
    # 
    def listen_to(event, &action)
      events[event] = action
    end
    
    # Execute registered action for notified event.
    # 
    def notify(event)
      events[event].call if events.has_key?(event)
    end
    
    private 
    
    def events
      @events ||= {}
    end
    
  end
  
end