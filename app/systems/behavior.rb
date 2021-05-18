class Behaviorsys < System

  def initialize
    super
    @writes += [Behavior, BehaviorSignal, Collider, Team]
  end
  def tick args, reg
    super
    puts "BEHAVIOR"

    # if the behaviorsys sends behaviorsignal, do we have to loop through it again?
    # or have one of these loops at beginning, one at end?
    do_behavior_signals args, reg

    if args.inputs.mouse.down
      @view[Behavior].each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    @view[Behavior].each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

    puts "here"
    @view[Collider].each_with_index do |collider, ent|
      # check collision (loop through other colliders)
      # if there's collision,
      # find behavior components of end that collided
      # send(:on_collision, args, thing_collidedr_with)
      collider.collides_with.each do |colliding_reg|
        puts "Colliding #{reg.name} and #{colliding_reg.name}"
        colliding_reg.view[Collider].each do |target|
          if collider.rect.intersect_rect? target.rect

            # eg if spell collides with mob, spell needs to react(change anim, then die)
            # and mob needs to react (take damage)
            # do this with behaviorsignals?

            # send behavior signal with relevant info - collidee xform and type (mob/spell)
            # or just call on collision wtf

            puts "COLLISION FOUND".green
            p collider.container
            p collider.ent
            p target.container
            p target.ent
            @view[Behavior][ent].send(:on_collision, args,
                                      ent: target.ent,
                                      reg: target.container)

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
    if @view[BehaviorSignal].any?
      @view[BehaviorSignal].each do |bs|
        @view[Behavior].each do |b|
          if b.ent == bs.ent && bs.handled == false
            b.handle(bs, args)
          end
        end
      end
    end
  end
end
