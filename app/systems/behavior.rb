class BehaviorSystem < System

  def initialize
    super
    @writes += [Behavior, BehaviorSignal, Collider, Team]
  end
  def tick args, reg
    super

    # if the behaviorsys sends behaviorsignal, do we have to loop through it again?
    # or have one of these loops at beginning, one at end?
    do_behavior_signals args, reg

    if args.inputs.mouse.down
      @view[Behavior].each do |b|
        next if b.nil?
        puts "MOUSE DOWN"
        b.on_mouse_down args
      end
    end

    @view[Behavior].each do |b|
      next if b.nil?
      b.on_key_down args
      b.on_tick args
    end

    @view[Collider].each_with_index do |collider, ent|
      #!!!!  TODO - collision is disabled
      break

      next if collider.nil?
      if @reg.name == "Misc"
        puts "Colliding #{@reg.name}".blue
      end

      collider.collides_with.each do |colliding_reg|
        puts "Colliding #{reg.name} and #{colliding_reg.name}"
        colliding_reg.view[Collider].each do |target|
          next if target.nil?
          next if colliding_reg.view[Team][target.ent] == @view[Team][ent]
          next if colliding_reg.view[Behavior][target.ent].enabled == false

          if collider.rect.intersect_rect? target.rect

            # eg if spell collides with mob, spell needs to react(change anim, then die)
            # and mob needs to react (take damage)
            # do this with behaviorsignals?

            # send behavior signal with relevant info - collidee xform and type (mob/spell)
            # or just call on collision wtf

            puts "COLLISION FOUND".green
            puts "#{collider.container.name}, #{collider.ent} - #{target.container.name}, #{target.ent}"
            @view[Behavior][ent].send(:on_collision, args,
                                      ent: target.ent,
                                      reg: target.container)

            colliding_reg.view[Behavior][target.ent].send(:on_collision, args, 
                                                          ent: ent,
                                                          reg: collider.container)

            break
            # @view[BehaviorSignal] << BehaviorSignal.new(ent: collider.ent,
            #                                             reg: collider.container
            #                                             type: Collider,
            #                                             target: target.ent,
            #                                             info: target.team)

          end
        end
      end
    end

    do_behavior_signals args, reg

  end

  def do_behavior_signals args, reg
    @view[BehaviorSignal].each do |bs|
      @view[Behavior].each do |b|
        next if b.nil?
        if b.ent == bs.ent && bs.handled == false
          b.handle(bs, args)
        end
      end
    end
  end

end
