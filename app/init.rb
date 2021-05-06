# palette:
def colorhex(str)
  color = []
  color << str[0..1].hex
  color << str[2..3].hex
  color << str[4..5].hex
end
Darkblue = colorhex('264653')
Green = colorhex('2a9d8f')
Yellow = colorhex('e9c46a')
Orange = colorhex('f4a261')
Red = colorhex('e76f51')
Black = colorhex('000000')
White = colorhex('ffffff')
Colors = [Darkblue,Green,Yellow,Orange,Red]

Gsize = 80        # size of squares in game grid
Known_anims = []


module Init

  def init_anims

    anim = Anim.new(name: :hero_idle, loop: true)
    (1..9).each do |i|
      anim << "sprites/archmage/arch-mage+female-idle-#{i}.png"
    end
    anim.duration = 120
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :hero_attack_staff)
    (1..2).each do |i|
      anim << "sprites/archmage/arch-mage+female-attack-staff-#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :adept_idle, loop: true)
    (1..9).each do |i|
      anim << "sprites/necromancer/adept-idle-#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :adept_magic)
    (1..3).each do |i|
      anim << "sprites/necromancer/adept-magic-#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

  end


  def init_hero args
    #args.state.hero = Ent.new
    ent = new_ent_id

    ########## Xform ##########

    args.state.xforms[ent] = Xform.new(ent: ent,x: 200,y:200,w:200,h:200)
    #args.state.xforms[ent] = [x: 200,y:200,w:200,h:200]

    ########## Animation ##########
   
    # this might be a tad confusing (or not)
    # Known_anims is an array of hashes, which are found by the index ent
    Known_anims[ent] = {}

    anims_to_add = [:hero_idle,:hero_attack_staff]
    anims_to_add.each do |name|

      anim = args.state.anim_pail[name]
      anim.ent = ent
      Known_anims[ent][name] = anim
    end

    # set anim to play
    args.state.anims << Known_anims[ent][:hero_idle].dup

    ########## Behavior ##########

    b = Behavior.new(ent: ent)

    # needs to have default behavior (eg idle anim)
    b.define_singleton_method(:default_anim) do |args|
      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      anim = Known_anims[ent][:hero_idle].dup

      # check if an animation with this ent is playing
      if args.state.anims.select { |anim| anim.ent == ent }

        args.state.anims << anim
      end
      puts "END DEFAULT"
      p args.state.anims
    end

    # needs to have a trigger (eg input) which has some effect (eg change anim)
    b.define_singleton_method(:on_mouse_down) do  |args|

      attack args

    end

    # would like the attack method to invoke the on_mouse_down method,
    # not the other way around
    # if it could be registered or something?
    b.define_singleton_method(:attack) do |args|
      
      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      
      # animation becomes attack
      args.state.anims << Known_anims[ent][:hero_attack_staff].dup
    end

    args.state.hero = ent
    args.state.behavior[ent] = b
  end

  def init_baddie args
    ent = new_ent_id

    ########## Xform ##########

    args.state.xforms[ent] = Xform.new(ent: ent,x: 900,y:400,w:200,h:200)

    ########## Animation ##########

    Known_anims[ent] = {}

    anims_to_add = [:adept_idle,:adept_magic]
    anims_to_add.each do |name|
      anim = args.state.anim_pail[name]
      anim.ent = ent
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
    args.state.behavior[ent] = b
  end

end
