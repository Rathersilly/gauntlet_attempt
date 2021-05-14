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
