  def init_steelclad args

    ent = new_entity_id args

    ########## Xform ##########

    args.state.xforms[ent] = Xform.new(ent: ent,x: 700,y:400,w:100,h:100)

    ########## Animation ##########

    Known_anims[ent] = {}

    anims_to_add = [:steelclad_run]
    anims_to_add.each do |name|
      anim = args.state.anim_pail[name]
      anim.ent = ent
      anim.loop = true
      #anim.flip_horizontally = true
      Known_anims[ent][name] = anim
    end
   
    ########## Behavior ##########

    b = Behavior.new(ent: ent)

    b.define_singleton_method(:default_anim) do |args|
      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      anim = Known_anims[ent][:steelclad_run].dup
      anim.loop = true

      # check if an animation with this ent is playing
      if args.state.anims.select { |anim| anim.ent == ent }

      end
      args.state.anims << anim
      puts "END DEFAULT"
      p args.state.anims

    end

    b.define_singleton_method(:attack) do |args|

      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }

      # animation becomes attack
      args.state.anims << Known_anims[ent][:adept_magic]
    end

    b.singleton_class.class_eval { include Mob4d }
    b.add_attribute(:speed, 2)


    # set anim to play
    args.state.anims << Known_anims[ent][:steelclad_run]

    args.state.baddie = ent
    args.state.behaviors << b
  end


