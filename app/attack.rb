class Attack
  attr_accessor :name, :anim, :atkframge, :dmg

  # for now lets keep the animation out of attack - might want same
  # anim for diff attacks after all
  def initialize traits
    #@anim = traits[:anim]
    @name = traits[:name]
    @name ||= "attack"
    @atkframe = traits[:atkframe]
    @atkframe ||= 0
    @dmg = traits[:dmg]
    @dmg ||= 1
    @started = false
  end

  def start args
      new_bullet = Bullet.new(x:args.state.guy.x, y: args.state.guy.y,
                              w: 200,h:200,
                              path: 'sprites/icemissile-ne-1.png',
                              speed: 14)
      new_bullet.set_dest(*args.inputs.mouse.point)
      args.state.good_ents << new_bullet
  end

  def calc(frame, args)
    if @started == false && frame == @atkframe
      @started = true
      start args
    end
  end

  def reset
    @started = false
  end
end

