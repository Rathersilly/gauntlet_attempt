class HealthSystem < System
  def initialize
    super
    @reads += [Health]
    @writes += [Behavior, BehaviorSignal]
  end

  def tick args, reg
    super
    # puts "HEALTH TICK".green
    # p @view[Health]
    @view[Health].each_with_index do |h, ent|
      if h.nil? || @view[Behavior][ent].status != :active

        
        next
      end
      # puts "HEALTH INNER"
      # p h
      # p h.health

      if h.health < 1
        p @view[Behavior][ent].status 
        @view[Behavior][ent].send(:on_zero_health, args)
      end
    end
  end

  end
