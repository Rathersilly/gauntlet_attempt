class ArchmageFactory < Factory
  class << self
    def anims
      Known_anims[@ent] = {}

      anims_to_add = [:hero_idle,:hero_attack_staff]
      anims_to_add.each do |name|

        anim = args.state.all_anims[name]
        anim.ent = @ent
        Known_anims[@ent][name] = anim
      end
      args.state.anims[@ent] = Known_anims[@ent][:hero_idle].dup
    end

    # haven't updated this yet - it will have normal mage animations
    def behavior(args)
      b = PlayerBehavior.new(ent: @ent, speed: 5)
      args.state.behaviors << b
    end
  end
end
