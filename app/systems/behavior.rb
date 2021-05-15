class BehaviorSystem

  def tick args

    state = args.state
    # this might get out of hand if many behaviors/signals
    # also these can be dried
    if state.spells.behavior_signals.any?
      state.spells.behavior_signals.each do |bs|
        state.spells.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    if state.mobs.behavior_signals.any?
      state.mobs.behavior_signals.each do |bs|
        state.mobs.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      state.mobs.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    state.mobs.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end
    state.spells.behaviors.each do |b|
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end
end
