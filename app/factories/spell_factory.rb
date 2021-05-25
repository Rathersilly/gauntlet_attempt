class IceMissileFactory < Factory
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
      puts "CREATING ICEMISSILE"
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

    def frame args, **opts
      Frame.new(path: 'sprites/icemissile-ne-3.png',angle: @angle)
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
      @angle = set_icemissile_angle [@xform.x, @xform.y], dest

      # compare dest to xform and adjust angle
      b
    end
    
    def set_icemissile_angle vec1, vec2
      Math.atan2(vec2[1]-vec1[1], vec2[0] - vec1[0]) * 180 / Math::PI - 30
    end
      

  end
end

# dir, dirx, and diry are kinda messy
class SpellBehavior < Behavior
  attr_accessor :dirx, :diry,:speed
  def initialize **opts
    super
    @speed = opts[:speed] || 0
    @dir = opts[:dir] || 0
    @damage = opts[:damage] || 1
  end

  def on_tick args
    xform = @container.view[Xform][@ent]
    if !@dirx
      @dirx, @diry = Tools.set_dir(xform, @dest)
    end
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end

  def on_collision args, **info
    puts "SPELL on_collision".blue
    p self
    p self.ent
    p @container
    puts "OTHER TEAM"
    #puts info[:reg][Team][info[:ent]]
    if @container.view[Team][@ent] != info[:reg].view[Team][info[:ent]]
      @container.delete(@ent)
    end
    #if info[:reg][Team][info[:ent]] == enemy team
    #if info[:team] == #enemy team
        # mark this spell as being done
        #end

  end
end


