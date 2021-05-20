class SorceressFactory < Factory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      {
        xform: @xform,
        collider: Collider.new(xform: @xform, collides_with: []),

        anim_group: anim_group(args, opts),
        behavior: behavior(args, opts),
        color: color(args,opts),
        team: opts[:team]
      }
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

      anims_to_add = %i[sorceress_run sorceress_melee]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.duration = 20
        anims << anim
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = PlayerBehavior.new(speed: 5)
    end
  end
end

