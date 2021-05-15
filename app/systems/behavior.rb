class Behaviorsys < System


  def tick args, reg
    super
    #!!!!!!!!!!!
    return

    # this might get out of hand if many behaviors/signals
    # also these can be dried
    if args.state.spells.behavior_signals.any?
      args.state.spells.behavior_signals.each do |bs|
        args.state.spells.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    if args.state.mobs.behavior_signals.any?
      args.state.mobs.behavior_signals.each do |bs|
        args.state.mobs.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      args.state.mobs.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    args.state.mobs.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end
    args.state.spells.behaviors.each do |b|
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end
end
