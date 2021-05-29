class Spawner < BeingFactory
  #spawner has location, health, sprite, team
  #static sprite? 
  class << self

    def frame args, **opts
      puts "SETTING FRAME".blue
      @path =  'sprites/scenery/dwarven-doors-closed.png'
      puts @path
      Frame.new(path: @path)

    end

    def health args, **opts
      Health.new(health: 1)
    end

    def behavior args, **opts
      b = SpawnerBehavior.new(ent: @ent)
    end

  end
end
class SpawnerBehavior < Behavior
  attr_accessor :max_cooldown

  def initialize(**opts)
    super
    @max_cooldown = opts[:cooldown] || 1
    @cooldown = @max_cooldown
  end

  def on_tick args
    return unless @enabled
    if args.state.tick_count % 60 == 0
      @cooldown -= 1
      if @cooldown == 0
        @cooldown = @max_cooldown
        args.state.mobs << SteelcladFactory.create(args, xform: @container.view[Xform][@ent].dup,
                                                   team: args.state.teams[:enemy])
      end
    end
  end

  def on_collision args, **info
      take_damage
  end

  def take_damage
    puts "SPAWNER TAKING DAMAGE"
    # p @container.view[Xform]
    # p @container.view[Xform][@ent]
    # p @container.view[Health][@ent].health
    @container.view[Health][@ent].health -= 1
  end

  def on_zero_health args
    puts "SPAWNER ZERO HP"
    @status = :dead
    disable
    @container.view[Frame][@ent] = {path: 'sprites/scenery/rubble.png'}
    # change frame
    #@container.delete @ent
  end

end
