class SorceressFactory < BeingFactory
  class << self

    def anim_group args, **opts
      anims =[] 

      anims_to_add = %i[sorceress_run sorceress_melee]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anim.duration = 20
        anims << anim
      end
      AnimGroup.new anims

    end

    def behavior args, **opts
      b = PlayerBehavior.new(speed: 5)
    end
  end
end

