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

class MageFactory < Factory
  class << self
    def anim(args)
      Known_anims[@ent] = {}

      anims_to_add = %i[mage_idle mage_attack_staff]
      anims_to_add.each do |name|
        anim = args.state.anim_pail[name]
        anim.ent = @ent
        Known_anims[@ent][name] = anim
      end
      args.state.anims << Known_anims[@ent][:mage_idle].dup
    end

    def behavior(args)
      b = PlayerBehavior.new(ent: @ent, speed: 5)
      args.state.behaviors << b
    end
  end
end

class PlayerBehavior < Behavior
  attr_accessor :speed

  def post_initialize(**opts)
    @speed = opts[:speed]
  end

  def default_anim(args)
    # reset animation
    args.state.anims.reject! { |x| x.ent == @ent }
    anim = Known_anims[@ent][:mage_idle].dup

    # check if an animation with this ent is playing
    if args.state.anims.select { |anim| anim.ent == @ent }

    end
    args.state.anims << anim
    puts 'END DEFAULT'
    p args.state.anims
  end

  # INPUT HANDLING
  def on_mouse_down(args)
    attack args
  end

  def on_key_down(args)
    move args
  end

  def attack(args)
    # reset animation
    args.state.anims.reject! { |x| x.ent == @ent }

    # animation becomes attack
    xform = args.state.xforms.find { |x| x.ent == @ent }
    anim = Known_anims[@ent][:mage_attack_staff].dup
    anim.flip_horizontally = true if args.inputs.mouse.x < xform.x
    args.state.anims << anim

    IceMissileFactory.create args, {parent: @ent}
    #projectile = IceMissile.new(args, @ent)
    #args.state.tents << projectile
    puts 'ANIM ADDED'
    p args.state.anims
    p args.state.effects
  end

  def move(args)
    xform = args.state.xforms.find { |x| x.ent == @ent }
    anim = args.state.anims.find { |x| x.ent == @ent }

    chars = args.inputs.keyboard.keys[:down_or_held]
    xform.y += @speed if args.inputs.keyboard.up
    if args.inputs.keyboard.left
      xform.x -= @speed
      anim.flip_horizontally = true if anim.name != :mage_attack_staff
    end
    xform.y -= @speed if args.inputs.keyboard.down
    if args.inputs.keyboard.right
      xform.x += @speed
      anim.flip_horizontally = false if anim.name != :mage_attack_staff
    end
  end
end

class ArchmageBehavior < PlayerBehavior
end