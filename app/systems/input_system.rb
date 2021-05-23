class InputSystem < System

  def initialize
    super
    @writes += [Behavior, BehaviorSignal, Collider, Team]
  end
  def tick args, reg
    super

    do_behavior_signals args, reg

    if args.inputs.mouse.down
      @view[Behavior].each do |b|
        next if b.nil?
        b.on_mouse_down args
      end
    end

    @view[Behavior].each do |b|
      next if b.nil?
      b.on_key_down args
      b.on_tick args
    end

    do_behavior_signals args, reg

  end

  # !!! TODO: this is also currently in behavior system
  def do_behavior_signals args, reg
    @view[BehaviorSignal].each do |bs|
      @view[Behavior].each do |bg|
        next if bg.nil?
        bg.each do |b|
          next if b.nil?
          if b.ent == bs.ent && bs.handled == false
            b.handle(bs, args)
          end
        end
      end
    end
  end
end
