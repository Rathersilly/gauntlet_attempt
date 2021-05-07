  class Fireball < Ent

  end

  class IceMissile < Ent
    attr_accessor :ent, :parent

    def initialize args, parent
      @parent = parent
      @ent = new_tent_id args

      p "NEW ICEMISSILE"
      xform = args.state.xforms[parent].dup
      anim = args.state.anim_pail[:ice_missile].dup
      anim.ent = ent
      args.state.anims << anim

      puts "new icemissile"
      puts "p: #{@parent}, e: #{@ent}"
      puts "a.s.entid : #{args.state.entity_id}"
      puts "a.s.tentid: #{args.state.tent_id}"


    end
  end

