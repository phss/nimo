require File.dirname(__FILE__) + '/../../spec_helper'

describe "Nimo::EventListener module" do
  
  class SomeEventListener
    include Nimo::EventListener
    attr_accessor :was_notified
    
    def initialize
      @was_notified = false
    end
  end
  
  it "should register and execute event" do
    listener = new_listener(:an_event)
    
    listener.notify(:an_event)
    listener.was_notified.should be_true
  end
  
  it "should not execute action for different event" do
    listener = new_listener(:an_event)
    
    listener.notify(:another_event)
    listener.was_notified.should be_false
  end
  
  def new_listener(event)
    listener = SomeEventListener.new
    listener.listen_to(event) { listener.was_notified = true }
    return listener
  end
  
end