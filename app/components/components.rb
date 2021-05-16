class Component
  attr_accessor :ent, :container

  def initialize(**opts)
    @ent          = opts[:ent]
    @container    = opts[:container]
  end
end

class Xform < Component
  attr_accessor :x, :y, :w, :h

  def initialize(**opts)
    super
    @x = opts[:x]  || 0
    @y = opts[:y]  || 0
    @w = opts[:w]  || 0
    @h = opts[:h]  || 0
  end

  def to_h
    { x: @x, y: @y, w: @w, h: @h }
  end
end

class Color < Component
  attr_accessor :r, :g, :b, :a

  def initialize(**opts)
    super
    @r = opts[:r]  || 0
    @g = opts[:g]  || 0
    @b = opts[:b]  || 0
    @a = opts[:a]  || 0
  end

  def to_h
    { r: @r, g: @g, b: @b, a: @a }
  end
end
