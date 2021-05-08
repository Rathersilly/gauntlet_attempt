def init_hero args
  #args.state.hero = Ent.new
  ent = new_entity_id

  ########## Xform ##########

  args.state.xforms[ent] = Xform.new(ent: ent,x: 200,y:200,w:100,h:100)
  #args.state.xforms[ent] = [x: 200,y:200,w:200,h:200]

  ########## Animation ##########

  # this might be a tad confusing (or not)
  # Known_anims is an array of hashes, which are found by the index ent
  Known_anims[ent] = {}

  anims_to_add = [:hero_idle,:hero_attack_staff]
  anims_to_add.each do |name|

    anim = args.state.anim_pail[name]
    anim.ent = ent
    Known_anims[ent][name] = anim
  end

  ########## Behavior ##########

  b = Behavior.new(ent: ent)
  b.add_attribute(:speed, 10)
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
    args.state.anims << Known_anims[ent][:hero_attack_staff].dup

    # create projectile
    args.state.tents << IceMissile.new(args, ent)
    puts "ANIM ADDED"
    p args.state.anims
    p args.state.effects
  end

  b.define_singleton_method(:move) do |args|
    xform = args.state.xforms.find { |x| x.ent == @ent }
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
    end
    if args.inputs.keyboard.down
      xform.y -= @speed
    end
    if args.inputs.keyboard.right
      xform.x += @speed
    end
  end

  ########## ADDING TO STATE ##########
  
  # set anim to play
  args.state.anims << Known_anims[ent][:hero_idle].dup

  args.state.hero = ent
  args.state.behaviors << b
end
