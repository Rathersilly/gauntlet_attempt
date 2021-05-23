class AnimGroup
  attr_accessor :anims

  def initialize anims
    @anims = anims
  end
  def [] index
    @anims[index]
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
