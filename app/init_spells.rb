  class Fireball < Ent

  end

  class IceMissile < Ent
    attr_accessor :ent, :parent

    def initialize args, parent
      @parent = parent
      @ent = new_entity_id args

      xform = args.state.xforms[parent].dup
      xform.ent = @ent
      xform.w = 50
      xform.h = 50

      args.state.xforms << xform
      anim = args.state.anim_pail[:ice_missile].dup
      anim.ent = ent
      anim.reset
      args.state.effects << anim

      p "NEW ICEMISSILE"
      puts "p: #{@parent}, e: #{@ent}"
      puts "a.s.entid : #{args.state.entity_id}"
      p args.state.effects


    end
  end

