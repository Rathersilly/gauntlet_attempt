class BeingFactory < Factory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      asdf={
        xform: @xform,
        collider: Collider.new(xform: @xform, collides_with: []),

        anim_group: anim_group(args, opts),
        behavior: behavior(args, opts),
        color: color(args,opts),
        team: opts[:team],
        health: health(args, opts),
        frame: frame(args,opts)
      }
      puts "CREATING:".magenta
      p asdf
      asdf
    end
      
    def xform args, **opts
      if opts[:xform]
        return opts[:xform].dup
      end
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

  end
end


