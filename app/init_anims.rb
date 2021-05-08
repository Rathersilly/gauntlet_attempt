  def init_anims

    ##### Hero (archmage-female) #####
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
    
    ##### Hero (mage-female) #####
    anim = Anim.new(name: :mage_idle, loop: true)
      anim << "sprites/mage-female/mage+female.png"
      anim << "sprites/mage-female/mage+female-attack-magic#{1}.png"
      anim << "sprites/mage-female/mage+female-attack-magic#{2}.png"
      anim << "sprites/mage-female/mage+female-attack-magic#{1}.png"
    anim.duration = 60
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :mage_attack_staff)
      anim << "sprites/mage-female/mage+female-defend.png"
      anim << "sprites/mage-female/mage+female-attack-staff#{1}.png"
      anim << "sprites/mage-female/mage+female-attack-staff#{2}.png"
    anim.duration = 30
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

    anim = Anim.new(name: :ice_missile)
    (1..7).each do |i|
      anim << "sprites/icemissile-ne-#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :siegetrooper_attack)
    (1..7).each do |i|
      #anim << "sprites/siegetrooper-attack-#{i}.png"
    end
      anim << "sprites/siegetrooper-attack-3.png"
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    ##### Steelclad #####

    anim = Anim.new(name: :steelclad_run)
    (1..10).each do |i|
      anim.add_frame "sprites/steelclad/steelclad-se-run#{i}.png"
    end
    (1..10).each do |i|
      anim.add_upframe "sprites/steelclad/steelclad-ne-run#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.megainspect

  end

