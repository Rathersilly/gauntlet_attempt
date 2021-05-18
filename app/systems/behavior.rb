class Behaviorsys < System

  def initialize
    super
    @writes += [Behavior, BehaviorSignal, Collider]
  end
  def tick args, reg
    super

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

    @view[Collider].each_with_index do |collider, ent|
      # check collision (loop through other colliders)
      # if there's collision,
      # find behavior components of end that collided
      # send(:on_collision, args, thing_collidedr_with)
      c.collides_with.each do |colliding_reg|
        colliding_reg.view[Collider].each do |target|
          if @view[Collider].intersect_rect? collider

            # eg if spell collides with mob, spell needs to react(change anim, then die)
            # and mob needs to react (take damage)
            # do this with behaviorsignals?

            # send behavior signal with relevant info - collidee xform and type (mob/spell)
            # or just call on collision wtf

            @view[Behavior][ent].send(:on_collision, args,
                                      ent: collider.ent,
                                      reg: collider.container)

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
          if b.ent == bs.ent && b.handled? == false
            b.handle(bs, args)
          end
        end
      end
    end
  end
end
