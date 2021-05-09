class ArchmageFactory < Factory
  class << self
    def anims
      Known_anims[@ent] = {}

      anims_to_add = [:hero_idle,:hero_attack_staff]
      anims_to_add.each do |name|

        anim = args.state.anim_pail[name]
        anim.ent = @ent
        Known_anims[@ent][name] = anim
      end
      args.state.anims << Known_anims[@ent][:hero_idle].dup
    end

    # haven't updated this yet - it will have normal mage animations
    def behavior(args)
      b = PlayerBehavior.new(ent: @ent, speed: 5)
      args.state.behaviors << b
    end
  end
end

=begin
  ########## Behavior ##########
  # keeping this here instead of in new class just for
  # reference purposes re: metaprogramming

  b = Behavior.new(ent: ent)
  b.add_attribute(:speed, 5)
  puts "SPEED"
  puts b.speed

  # needs to have default behavior (eg idle anim)
  b.define_singleton_method(:default_anim) do |args|
    # reset animation
    args.state.anims.reject! {|x| x.ent == ent }
    anim = Known_anims[ent][:hero_idle].dup

    # check if an animation with this ent is playing
    if args.state.anims.select { |anim| anim.ent == ent }

    end
      args.state.anims << anim
    puts "END DEFAULT"
    p args.state.anims
  end

  # INPUT HANDLING
  b.define_singleton_method(:on_mouse_down) do  |args|
    attack args
  end

  b.define_singleton_method(:on_key_down) do  |args|
    move args
  end

  # would like the attack method to invoke the on_mouse_down method,
  # not the other way around
  # if it could be registered or something?
  b.define_singleton_method(:attack) do |args|

    # reset animation
    args.state.anims.reject! {|x| x.ent == ent }

    # animation becomes attack
    xform = args.state.xforms.find { |x| x.ent == @ent }
    anim = Known_anims[ent][:hero_attack_staff].dup
    if args.inputs.mouse.x < xform.x
      anim.flip_horizontally = true
    end
    args.state.anims << anim

    # create projectile
    proj = IceMissile.new(args, ent)
    args.state.tents << proj
    puts "ANIM ADDED"
    p args.state.anims
    p args.state.effects
  end

  b.define_singleton_method(:move) do |args|
    xform = args.state.xforms.find { |x| x.ent == @ent }
    anim = args.state.anims.find { |x| x.ent == @ent }
    #puts "MOVING"
    #p args.inputs.keyboard.key
    #p args.inputs.keyboard.keys
    #p args.inputs.keyboard.key_down
    chars = args.inputs.keyboard.keys[:down_or_held]
    if args.inputs.keyboard.up
      xform.y += @speed
    end
    if args.inputs.keyboard.left
      xform.x -= @speed
      anim.flip_horizontally = true if anim.name != :hero_attack_staff
    end
    if args.inputs.keyboard.down
      xform.y -= @speed
    end
    if args.inputs.keyboard.right
      xform.x += @speed
      anim.flip_horizontally = false if anim.name != :hero_attack_staff
    end
  end

  ########## ADDING TO STATE ##########
  
  # set anim to play
  args.state.anims << Known_anims[ent][:hero_idle].dup

  args.state.hero = ent
  args.state.behaviors << b
end
=end
