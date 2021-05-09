  def init_baddie args

    ent = new_entity_id args

    ########## Xform ##########

    args.state.xforms[ent] = Xform.new(ent: ent,x: 900,y:400,w:100,h:100)

    ########## Animation ##########

    Known_anims[ent] = {}

    anims_to_add = [:adept_idle,:adept_magic]
    anims_to_add.each do |name|
      anim = args.state.anim_pail[name]
      anim.ent = ent
      anim.flip_horizontally = true
      Known_anims[ent][name] = anim
    end

    # set anim to play
    args.state.anims << Known_anims[ent][:adept_idle]
   
    ########## Behavior ##########

    b = Behavior.new(ent: ent)

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
