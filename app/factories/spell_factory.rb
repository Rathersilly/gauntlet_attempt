class IceMissileFactory < Factory
  class << self

    def before args, **opts
      puts "BEFORE ICEMISSILE"
      @parent = opts[:parent]
      @parent_container = opts[:parent_container]
      @spell = true
      @w ||= 50
      @h ||= 50
    end

    def xform args, **opts
      xform = @parent_container.xforms[@parent].dup
      xform.w = @w
      xform.h = @h
      xform
    end

    def anim_store args, **opts
      anims =[] 

      anims_to_add = %i[ice_missile]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
      end
      anims

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
    xform = @container.xforms[@ent]
    if !@dirx
      @dirx, @diry = Tools.set_dir(xform, @dest)
    end
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end
end


