#lets try module with class functions maybe

class BlockFactory < Factory
  # has xform, color
  class << self
    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def color args, opts
      Color.new opts
    end

  end
end
