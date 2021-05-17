class AnimGroup
  attr_accessor :anims

  def initialize anims
    @anims = anims
  end
  def [] index
    @anims[index]
  end
end

