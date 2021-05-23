class AnimGroup
  attr_accessor :anims

  def initialize anims
    @anims = anims
  end
  def [] index
    @anims[index]
  end
end

class BehaviorGroup < Component
  attr_accessor :behaviors

  def initialize opts
    @behaviors = []
  end
  def [] index
    @behaviors[index]
  end
  def << thing
    @behaviors << thing
  end
  def each
    @behaviors.each do |b|
      yield b
    end
  end
end

# ColliderGroup is NYI
class ColliderGroup
  attr_accessor :colliders

  def initialize colliders
    @colliders = colliders
  end
  def [] index
    @colliders[index]
  end
end
