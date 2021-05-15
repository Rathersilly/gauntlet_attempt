class Behaviorsys < System


  def tick args, reg
    super

    if @registry.behavior_signals.any?
      @registry.behavior_signals.each do |bs|
        @registry.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    if args.inputs.mouse.down
      @registry.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    @registry.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end
end
