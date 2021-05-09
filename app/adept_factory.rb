class AdeptFactory < Factory
  class << self
    def anim(args)
      Known_anims[@ent] = {}

      anims_to_add = [:adept_idle,:adept_magic]
      anims_to_add.each do |name|
        anim = args.state.anim_pail[name]
        anim.ent = @ent
        anim.flip_horizontally = true
        Known_anims[@ent][name] = anim
      end
      args.state.anims << Known_anims[@ent][:adept_idle].dup
    end

    def behavior(args)
      b = AdeptBehavior.new(ent: @ent)
      args.state.behaviors << b
    end

  end
end

class AdeptBehavior < Behavior


end
