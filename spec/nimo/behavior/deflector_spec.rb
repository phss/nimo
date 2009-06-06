require File.dirname(__FILE__) + '/../../spec_helper'

class StubDeflector < Nimo::GameObject
  include Nimo::Behavior::Deflector
  
  def self.for_test
    StubDeflector.new(:x => 100, :y => 100, :width => 20, :height => 5)
  end
end

class StubProjectile < Nimo::GameObject
  include Nimo::Behavior::Projectile
end

describe Nimo::Behavior::Deflector do
  
  def new_ball_at(x, y)
    return StubProjectile.new(:x => x, :y => y, :width => 5, :height => 5, :velocity => Object.from_hash(:x => 0.2, :y => 0.7))
  end
  
  it "should not deflect when deflector does not collide with ball" do
    ball = new_ball_at(0, 0)
    previous_velocity = ball.velocity.clone

    StubDeflector.for_test.deflect(ball)
    
    ball.velocity.x.should == previous_velocity.x
    ball.velocity.y.should == previous_velocity.y
  end
  
  it "should deflect vertically when hitted from above/below" do
    ball = new_ball_at(105, 98)
    previous_velocity = ball.velocity.clone
    
    StubDeflector.for_test.deflect(ball)
    
    ball.velocity.x.should == previous_velocity.x
    ball.velocity.y.should == -previous_velocity.y
  end

  it "should deflect horizontally when hitted from left/right" do
    ball = new_ball_at(97, 100)
    previous_velocity = ball.velocity.clone
    
    StubDeflector.for_test.deflect(ball)
    
    ball.velocity.x.should == -previous_velocity.x
    ball.velocity.y.should == previous_velocity.y
  end

end
