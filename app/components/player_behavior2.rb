module PlayerSubBehaviors
  class IceMissile < Behavior
    def on_mouse_down args
      puts "IceMissile MOUSE DOWN".blue
      return unless @group.weapon == :ice_missile
        shoot_ice_missile args if @group.cooldown == 0
    end

    def shoot_ice_missile args
      # shoots ice missile at mouse coords
      puts "IceMissile SHOOT".blue
      xform = @container[Xform][@ent]

      # give mage their attack animation
      current_anim = @container[AnimGroup][@ent][0]
      anim = @container[AnimGroup][@ent][1].dup
      if args.inputs.mouse.x < xform.x
        anim.flip_horizontally = true 
      elsif args.inputs.mouse.x > xform.x && current_anim.flip_horizontally == true
      end
      current_anim.flip_horizontally = anim.flip_horizontally
      args.state.mobs[Anim][@ent] = anim

      args.state.spells << IceMissileFactory.create(args, parent_container: @container,
                                                    parent: @ent,
                                                    team: @container[Team][@ent])
    end
  end

  class Fireball < Behavior
    def shoot_fireball_at args, target
      puts "Fireball SHOOT".blue
      xform = @container[Xform][@ent]

      # give mage their attack animation
      current_anim = @container[AnimGroup][@ent][0]
      anim = @container[AnimGroup][@ent][1].dup
      if args.inputs.mouse.x < xform.x
        anim.flip_horizontally = true 
      elsif args.inputs.mouse.x > xform.x && current_anim.flip_horizontally == true
      end

      current_anim.flip_horizontally = anim.flip_horizontally
      args.state.mobs[Anim][@ent] = anim
      args.state.spells << FireballFactory.create(args, parent_container: @container,
                                                    parent: @ent,
                                                    target: target,
                                                    team: @container[Team][@ent])

    end
  end

  class Move < Behavior

    def on_key_down args
      move args
    end

    def move args 
      return unless @group.mobile == true

      xform = @container.view[Xform][@ent]
      anim = @container.view[Anim][@ent]
      speed = @group.speed

      chars = args.inputs.keyboard.keys[:down_or_held]
      xform.y += speed if args.inputs.keyboard.up
      if args.inputs.keyboard.left
        xform.x -= speed
        anim.flip_horizontally = true if anim.name != :mage_attack_staff
      end
      xform.y -= speed if args.inputs.keyboard.down
      if args.inputs.keyboard.right
        xform.x += speed
        anim.flip_horizontally = false if anim.name != :mage_attack_staff
      end
    end

    def on_collision args, **info
      puts "mage on_collision".blue
    end

  end
end
