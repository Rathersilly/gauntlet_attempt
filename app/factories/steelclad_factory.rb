class SteelCladFactory < Factory
  class << self
    def anim args
      Known_anims[@ent] = {}

      anims_to_add = [:steelclad_run]
      anims_to_add.each do |name|
        anim = args.state.anim_pail[name]
        anim.ent = @ent
        anim.loop = true
        #anim.flip_horizontally = true
        Known_anims[@ent][name] = anim
      end
      args.state.anims[@ent] = Known_anims[@ent][:steelclad_run].dup
    end

    def behavior(args)
      b = SteelcladBehavior.new(ent: @ent, speed: 2)
      args.state.behaviors << b
    end

  end
end

class SteelcladBehavior < Behavior
  attr_accessor :speed
  include Mob4d

  def post_initialize(**opts)
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



