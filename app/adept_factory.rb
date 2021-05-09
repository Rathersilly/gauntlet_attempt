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


=begin
  def default_anim(args)
    # needs to have default behavior (eg idle anim)
    b.define_singleton_method(:default_anim) do |args|
    end

    b.define_singleton_method(:attack) do |args|
      
      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      
      # animation becomes attack
      args.state.anims << Known_anims[ent][:adept_magic]
    end

    args.state.baddie = ent
    args.state.behaviors << b
  end
=end
end
