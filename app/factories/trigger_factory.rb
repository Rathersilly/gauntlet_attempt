class TriggerFactory < Factory
  # trigger has xform and behavior
  # collision between xform and it's collidables triggers behavior
  class << self
    def xform args, **opts
      if opts[:xform]
        return opts[:xform].dup
      end
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      @xform = Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def collider args, opts
      Collider.new(xform:@xform, collides_with: [args.state.mobs])
    end

    def behavior args, **opts
      b = TriggerBehavior.new
    end

  end
end

class TriggerBehavior < Behavior
  attr_accessor :target_ent, :target_container

  def initialize **opts
    @repeatable          = opts[:repeatable]      || false
    @cooldown            = opts[:cooldown]        || 0
    @times_triggered     = opts[:times_triggered] || 0
    @event               = opts[:event]
    @target_ent               = opts[:target_ent]
    @target_container               = opts[:target_container]
  end

  def on_collision args, **info
    puts "TRIGGER COLLISION".green
    return if @times_triggered > 0 && @repeatable == false
    if info[:ent] == 0
      @times_triggered += 1

      @target_container[BehaviorSignal] << BehaviorSignal.new(ent: @target_ent,
                                                              type: Event,
                                                              message: :first_speech)
    end
  end

end



