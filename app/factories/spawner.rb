class Spawner < BeingFactory
  #spawner has location, health, sprite, team
  #static sprite? 
  class << self

    def health args, **opts
      Health.new(health: opts[:health])
    end

    def behavior args, **opts
      b = SpawnerBehavior.new(ent: @ent)
    end

  end
end
class SpawnerBehavior < Behavior
  attr_accessor 

  def initialize(**opts)
    super
  end
end
