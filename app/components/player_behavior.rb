class PlayerBehavior < Behavior
  attr_accessor :speed, :weapon

  def initialize(**opts)
    super
    @speed = opts[:speed]
    @weapon = :ice_missile
    @weapon = :politeness
    @status = :busy
    @cooldown = 2
    @mobile = true
  end

  def default_anim(args)
    # reset animation
    #puts 'DEFAULT ANIM'

    anim = @container.view[AnimGroup][@ent][0]
    @container.view[Anim][@ent] = anim


    #puts 'END DEFAULT'
    #Tools.megainspect anim
  end

  # INPUT HANDLING
  def on_mouse_down args
    return if @cooldown > 0
    attack args
  end

  def on_key_down args
    move args
  end

  def attack args
    #return if @busy == true
    puts "ATTACKING"
    # puts @ent
    # Tools.megainspect self
    # puts "ANIMS"
    # p args.state.anims

    if @weapon == :ice_missile
      shoot_ice_missile args
    elsif @weapon == :politeness

      # check range - if range is too short, give helpful arrow and help message

      xform = @container[Xform][@ent]
      puts "POLITENESS"
      dist = args.geometry.distance(xform, args.inputs.mouse)
      p dist
      # find the dwarf you're speaking to
      target = 0
      args.state.mobs.view[Xform].each_with_index do |xform, ent|
        if args.geometry.inside_rect?({x:args.inputs.mouse.x, y:args.inputs.mouse.y,w:1,h:1}, xform.to_h)
          target = ent
        end
      end

      if dist < 100 && target > 2
        @status = :talking
        @mobile = false
        talk args
      end
    end
  end

  def on_tick args
    if @status == :talking
      talk args
    end
    if args.state.tick_count % 60 == 0
      if @cooldown > 0
        @status = :default
        @cooldown -= 1 
      end
    end
  end

  def talk args
    puts "TALKING"
    @time ||= 0
    @time += 1

    xform = @container[Xform][@ent]
    msg = "No! The DWARVES are cutting down the SACRED GROVE"
    if @time >= msg.length
      @status = :default
      @mobile = true
      @time = nil
      return 
    end
    args.outputs.labels << [xform.x,xform.y + 120, msg[0..@time],6,1, *White,255]

  end

  def shoot_ice_missile
    xform = @container.view[Xform][@ent]

    # give mage their attack animation
    current_anim = @container.view[AnimGroup][@ent][0]
    anim = @container.view[AnimGroup][@ent][1].dup
    if args.inputs.mouse.x < xform.x
      anim.flip_horizontally = true 
    elsif args.inputs.mouse.x > xform.x && current_anim.flip_horizontally == true
    end
    current_anim.flip_horizontally = anim.flip_horizontally
    args.state.mobs.view[Anim][@ent] = anim

    args.state.spells << IceMissileFactory.create(args, parent_container: @container,
                                                  parent: @ent,
                                                  team: @container.view[Team][@ent])
  end

  def move(args)
    return unless @mobile == true

    xform = @container.view[Xform][@ent]
    anim = @container.view[Anim][@ent]

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

  def on_collision args, **info
    puts "mage on_collision".blue
  end
end

class ArchmageBehavior < PlayerBehavior
end

