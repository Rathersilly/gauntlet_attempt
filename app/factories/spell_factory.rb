class MissileFactory < Factory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      {
        xform: @xform,
        collider: collider(args, opts),

        behavior: behavior(args, opts),

        # not animating sprite for performance
        # anim_group: anim_group(args, opts),
        frame: frame(args,opts),
        color: color(args,opts),
        team: @team
      }
    end

    def before args, **opts
      puts "CREATING MISSILE"
      @parent = opts[:parent]
      @parent_container = opts[:parent_container]
      @team = opts[:team]
      @w ||= 50
      @h ||= 50
    end

    def collider args, opts
      Collider.new(xform:@xform, collides_with: [args.state.mobs])
    end

    def xform args, **opts
      xform = @parent_container.view[Xform][@parent].dup
      xform.x += 20
      xform.y += 20
      xform.w = @w#/2
      xform.h = @h#/2
      xform
    end

    def set_missile_angle vec1, vec2
      Math.atan2(vec2[1]-vec1[1], vec2[0] - vec1[0]) * 180 / Math::PI - 30
    end
  end
end

class IceMissileFactory < MissileFactory
  class << self

    def frame args, **opts
      Frame.new(path: 'sprites/fireball-nw.png',angle: @angle)
    end

    def anim_group args, **opts
      anims =[] 

      anims_to_add = %i[ice_missile]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.angle = @angle
        anims << anim
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = SpellBehavior.new(name: :ice_missile, speed: 10)
      dest = b.set_dest(args, [args.inputs.mouse.x, args.inputs.mouse.y])
      @angle = set_missile_angle [@xform.x, @xform.y], dest

      # compare dest to xform and adjust angle
      b
    end
    
  end
end

class FireballFactory < MissileFactory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      {
        xform: @xform,
        collider: collider(args, opts),

        behavior: behavior(args, opts),

        anim_group: anim_group(args, opts),
        # frame: frame(args,opts),
        color: color(args,opts),
        team: @team
      }
    end

    def xform args, **opts
      xform = @parent_container.view[Xform][@parent].dup
      xform.x += 20
      xform.y += 20
      xform.w = 200
      xform.h = 200
      xform
    end

    def frame args, **opts
      Frame.new(path: 'sprites/fireball-nw.png',angle: @angle)
    end

    def anim_group args, **opts
      anims =[] 

      anims_to_add = %i[fireball fireball_hit]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.angle = @angle
        anims << anim
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = FireballBehavior.new(name: :fireball, speed: 20)
      target = opts[:target]
      dest = b.set_dest(args, [args.state.mobs[Xform][target].x,args.state.mobs[Xform][target].y])
      @angle = set_missile_angle [@xform.x, @xform.y], dest

      b
    end
  end
end

