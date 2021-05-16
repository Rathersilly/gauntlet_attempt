class MageFactory < Factory
  class << self
    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def anim_store args, **opts
      anims =[] 

      anims_to_add = %i[mage_idle mage_attack_staff]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
      end
      AnimStore.new anims

    end

    def behavior args, **opts
      b = PlayerBehavior.new(speed: 5)
    end
  end
end

class PlayerBehavior < Behavior
  attr_accessor :speed

  def initialize(**opts)
    super
    @speed = opts[:speed]
  end

  def default_anim(args)
    # reset animation
    #puts 'DEFAULT ANIM'

    anim = @container.anim_stores[@ent][0]
    @container.anims[@ent] = anim


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
    # puts @ent
    # Tools.megainspect self
    # puts "ANIMS"
    # p args.state.anims

    xform = @container.xforms[@ent]
    #should change this from array index to :mage_attack_staff
    anim = @container.anim_stores[@ent][1].dup
    anim.flip_horizontally = true if args.inputs.mouse.x < xform.x
    args.state.mobs.anims[@ent] = anim

    args.state.spells << IceMissileFactory.create(args, {parent_container: @container,parent: @ent})

  end

  def move(args)

    xform = @container.xforms[@ent]
    anim = @container.anims[@ent]

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
