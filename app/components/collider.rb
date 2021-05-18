class Collider < Component
  attr_accessor :xform, :offset, :collides_with

  def initialize(**optarray)
    super
      @xform = optarray[:xform]
      @offset = optarray[:offset]
      @collides_with = optarray[:collides_with] || []

  end

  def rect
    @xform.rect
  end

end
