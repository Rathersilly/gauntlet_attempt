class Collision < System
  def initialize
    super
    @reads += [Collider]
    @writes += [Behavior, BehaviorSignal]
  end

  def tick args, reg
    
  end
end
