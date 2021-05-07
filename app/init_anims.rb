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

    anim = Anim.new(name: :ice_missile)
    (1..7).each do |i|
      anim << "sprites/icemissile-ne-#{i}.png"
    end
    state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect
  end

