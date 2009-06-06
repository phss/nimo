require File.dirname(__FILE__) + '/../../spec_helper'

class StubProjectile < Nimo::GameObject
  include Nimo::Behavior::Projectile
end

class StubDeflector
  def deflect(projectile)
    projectile.velocity.x = -projectile.velocity.x
  end
end

describe Nimo::Behavior::Projectile do
  
  it "should move according to speed and velocity" do
    projectile = StubProjectile.new(:speed => 10, :velocity => Object.from_hash(:x => 0.2, :y => 0.5))
    
    projectile.move
    
    projectile.x.should == 2
    projectile.y.should == 5
  end
  
  it "should be deflected" do
    projectile = StubProjectile.new(:speed => 10, :velocity => Object.from_hash(:x => 0.2, :y => 0.5))
    projectile.with_deflectors(StubDeflector.new)
    
    projectile.move
    
    projectile.x.should == -2
    projectile.y.should == 5
  end
  
end