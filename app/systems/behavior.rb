class Behaviorsys < System

  def initialize
    super
    @writes += [Behavior, BehaviorSignal]#, Collider]
  end
  def tick args, reg
    super

    if @view[BehaviorSignal].any?
      @view[BehaviorSignal].each do |bs|
        @view[Behavior].each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    if args.inputs.mouse.down
      @view[Behavior].each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    @view[Behavior].each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

    #@view[Collider].each do |c|
      # check collision (loop through other colliders
      # if there's collision,
      # find behavior components of end that collided
      # send(:on_collision, args, thing_collidedr_with)
  end
end
