class AdeptFactory < Factory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      {
        xform: @xform,
        collider: Collider.new(xform:@xform),

        anim_group: anim_group(args, opts),
        behavior: behavior(args, opts),
        color: color(args,opts)
      }
    end

    def before args, opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
    end

    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def anim_group args, **opts
      anims =[] 

      anims_to_add = %i[adept_idle adept_magic]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
        anim.flip_horizontally = true
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = AdeptBehavior.new
    end

  end
end

class AdeptBehavior < Behavior


end
