class SteelCladFactory < Factory
  class << self
    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def anim_store args, **opts
      anims =[] 

      anims_to_add = [:steelclad_run]
      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.loop = true
        anim.duration = 60
        anims << anim
      end
      anims
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

  # # TODO
  # def attack args
  # end

end



