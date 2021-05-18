class IceMissileFactory < Factory
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

    def before args, **opts
      puts "BEFORE ICEMISSILE"
      @parent = opts[:parent]
      @parent_container = opts[:parent_container]
      @spell = true
      @w ||= 50
      @h ||= 50
    end

    def xform args, **opts
      xform = @parent_container.view[Xform][@parent].dup
      xform.w = @w
      xform.h = @h
      xform
    end

    def anim_group args, **opts
      anims =[] 

      anims_to_add = %i[ice_missile]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = SpellBehavior.new(name: :ice_missile, speed: 10)
      b.set_dest(args, [args.inputs.mouse.x, args.inputs.mouse.y])
      b
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
  end

  def on_tick args
    xform = @container.view[Xform][@ent]
    if !@dirx
      @dirx, @diry = Tools.set_dir(xform, @dest)
    end
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end
end


