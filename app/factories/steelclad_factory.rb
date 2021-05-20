class SteelCladFactory < Factory
  class << self
    def create args, **opts
      before args, opts
      @xform = xform(args, opts)
      {
        xform: @xform,
        collider: Collider.new(xform: @xform, collides_with: []),

        anim_group: anim_group(args, opts),
        behavior: behavior(args, opts),
        color: color(args,opts),
        team: opts[:team],
        health: health(args, **opts)
      }
    end
    def health args, **opts
      Health.new(health: opts[:health])
    end

    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
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



