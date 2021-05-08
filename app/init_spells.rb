class Fireball < Ent

end

class IceMissile < Ent
  attr_accessor :ent, :parent

  def initialize args, parent
    @parent = parent
    @ent = new_entity_id args

    xform = args.state.xforms[parent].dup
    xform.ent = @ent
    xform.w = 50
    xform.h = 50
    args.state.xforms << xform

    anim = args.state.anim_pail[:ice_missile].dup
    anim.ent = ent
    anim.reset
    args.state.effects << anim

    behavior = SpellBehavior.new(name: :ice_missile, ent: @ent, speed: 10)
    behavior.set_dir(args, [args.inputs.mouse.x, args.inputs.mouse.y])
    args.state.behaviors << behavior

    p "NEW ICEMISSILE"
    puts "p: #{@parent}, e: #{@ent}"
    puts "a.s.entid : #{args.state.entity_id}"
    p args.state.effects


  end
end

class SpellBehavior < Behavior
  attr_accessor :dirx, :diry,:speed
  def post_initialize **opts
    @speed = opts[:speed] || 0
    @dir = opts[:dir] || 0
  end


  def on_tick args
    xform = args.state.xforms.find { |xform| xform.ent == @ent }
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end
end


