class Factory
  class << self
    def create(args, **opts)
      before args, opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      @color      = opts[:color]
      @ent = new_entity_id args

      puts "CREATED BEING: id##{@ent} @ #{@x}, #{@y}"

      xform args
      anim args
      behavior args
      after args
    end
    def before args, opts
      # override this in subclasses if needed
    end
    def after args
      # override this in subclasses if needed
    end

    def new_entity_id(args)
      args.state.entity_id += 1
    end

    def xform(args)
      args.state.xforms[@ent] = Xform.new(ent: @ent, x: @x, y: @y, w: @w, h: @h)
    end
  end
end

