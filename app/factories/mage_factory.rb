class MageFactory < Factory
  class << self
    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      {x: @x, y: @y, w: @w, h: @h}
    end

    def anim_store args, **opts
      anims =[] 

      anims_to_add = %i[mage_idle mage_attack_staff]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
      end
      anims

    end

    def behavior args, **opts
      b = PlayerBehavior.new(ent: @ent, speed: 5)
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
    #anim = Known_anims[@ent][:mage_idle].dup
    #args.state.anims[@ent] = anim

    #puts 'END DEFAULT'
    #Tools.megainspect anim
  end

  # INPUT HANDLING
  def on_mouse_down(args)
    attack args
  end

  def on_key_down(args)
    move args
  end

  def attack(args)
    puts "ATTACKING"
    puts @ent
    Tools.megainspect self
    puts "ANIMS"
    p args.state.anims

    xform = args.state.xforms[@ent]
    anim = Known_anims[@ent][:mage_attack_staff].dup
    anim.flip_horizontally = true if args.inputs.mouse.x < xform.x
    args.state.anims[@ent] = anim

    IceMissileFactory.create args, {parent: @ent}

    puts 'ANIM ADDED'
    p args.state.anims
  end

  def move(args)
    xform = args.state.xforms[@ent]
    anim = args.state.anims[@ent]

    chars = args.inputs.keyboard.keys[:down_or_held]
    xform[:y] += @speed if args.inputs.keyboard.up
    if args.inputs.keyboard.left
      xform[:x] -= @speed
      anim.flip_horizontally = true if anim.name != :mage_attack_staff
    end
    xform[:y] -= @speed if args.inputs.keyboard.down
    if args.inputs.keyboard.right
      xform[:x] += @speed
      anim.flip_horizontally = false if anim.name != :mage_attack_staff
    end
  end
end

class ArchmageBehavior < PlayerBehavior
end
