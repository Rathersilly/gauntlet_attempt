class SteelCladFactory < BeingFactory
  class << self
    def health args, **opts
      Health.new(health: opts[:health])
    end

    def anim_group args, **opts
      anims = [] 

      anims_to_add = [:steelclad_run]
      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.end_action = :loop
        anim.duration = 60
        anims << anim
      end
      AnimGroup.new anims
    end

    def behavior args, **opts
      b = SteelcladBehavior.new(ent: @ent, speed: 2)
    end

  end
end

class SteelcladBehavior < Behavior
  attr_accessor :speed
  include Mob4d

  def initialize(**opts)
    super
    @speed = opts[:speed]
  end

  # def default anim, args
  #   puts "STEELCLAD DEFAULT"

  #   anim = Known_anims[ent][:steelclad_run].dup
  #   anim.loop = true

  #   args.state.anims[@ent] = anim
  #   puts "END DEFAULT"
  #   p args.state.anims

  # end
  def on_collision args, **info
    puts "steelclad on_collision".blue
    p info[:ent]
    p info[:reg].name
    if info[:reg].name == "Spells"
      take_damage
      puts "SPELLS"
    end
  end

  def take_damage
    puts "TAKING DAMAGE"
    # p @container.view[Xform]
    # p @container.view[Xform][@ent]
    # p @container.view[Health][@ent].health
    @container.view[Health][@ent].health -= 1
  end

  def on_zero_health args
    puts "ZERO HP"
    @container.delete @ent

  end


end



