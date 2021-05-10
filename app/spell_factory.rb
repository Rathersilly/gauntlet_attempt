class Fireball < Ent

end

class IceMissileFactory < Factory
  class << self

    def before args, **opts
      puts "BEFORE ICEMISSILE"
      @parent = opts[:parent]
      @w ||= 50
      @h ||= 50
    end

    def xform(args)
      xform = args.state.xforms[@parent].dup
      xform.ent = @ent
      xform.w = @w
      xform.h = @h
      args.state.xforms[@ent] = xform
    end

    def anim args
      anim = args.state.anim_pail[:ice_missile].dup
      anim.ent = @ent
      args.state.spell_anims[@ent] = anim
    end

    def behavior args
      behavior = SpellBehavior.new(name: :ice_missile, ent: @ent, speed: 10)
      behavior.set_dir(args, [args.inputs.mouse.x, args.inputs.mouse.y])
      args.state.behaviors << behavior
    end

    def after args
      p "NEW ICEMISSILE"
      puts "p: #{@parent}, e: #{@ent}"
      puts "a.s.entid : #{args.state.entity_id}"
      p args.state.spell_anims
    end

  end
end

class SpellBehavior < Behavior
  attr_accessor :dirx, :diry,:speed
  def post_initialize **opts
    @speed = opts[:speed] || 0
    @dir = opts[:dir] || 0
  end

  def on_tick args
    xform = args.state.xforms[@ent]
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end
end


