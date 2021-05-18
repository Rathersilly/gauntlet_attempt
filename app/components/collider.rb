class Collider < Component
  attr_accessor :xform, :offset, :collides_with

  def initialize(**opts)
    super
      @xform = opts[:xform]
      @offset = opts[:offset]
      @collides_with = opts[:collides_with] || []

  end

  def rect
    @xform.rect
  end

end
