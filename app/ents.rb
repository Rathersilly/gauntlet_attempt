class Rect 
  attr_accessor :x,:y, :w,:h
  def initialize(x,y,w,h,color)
    @x=x
    @y=y
    @w=w
    @h=h
    @color = color
  end
end
class Explosion

end

class Ent
  attr_accessor :x,:y, :w,:h,:speed,:color,:angle, :status, :hp, :max_hp, :hitbox, :angle
  attr_accessor :invincible_timer, :invincible_length, :anim_state
  attr_accessor :atkspd, :atkcd

  def initialize(traits)
    #p traits
    @traits = traits
    @x = traits[:x]
    @y = traits[:y]
    @w = traits[:w]
    @w ||= 100
    @h = traits[:h]
    @h ||= 100
    @path = traits[:path]
    @color = traits[:color]
    @color ||= Green
    @border = traits[:border]
    @border ||= Darkblue
    @flip_h = traits[:flip_h]
    @flip_h           ||= false
    @flip_v = traits[:flip_v]
    @flip_v           ||= false
    @angle = traits[:angle]
    @speed = traits[:speed]
    @speed ||= 6
    @status ||= :normal
    @invincible_length  ||= 60
    @invincible_timer   ||=0

    @max_hp           ||= 10
    @hp               ||= 10
    @atkspd           ||= 60
    @atkcd            ||= 0


    @anim_state       ||= :idle
    @anims            ||= {}
    @path ||= 'sprites/sylph.png'
    @anims[:idle] ||= Anim.new(name: :idle,path: @path)
    @anims[:idle].loop = true


    #elsif traits.size > 1      # was going to give option to init as array
    @path ||= 'sprites/misc/dragon-0.png'
    @anims ||= Anim.new(name: :idle,path: @path)
  end
  def rect
    [@x,@y,@w,@h]
  end

  def set_dest *dest
    #puts dest
    if dest[0].class == Array
      @destx, @desty = dest[0]
    else
      @destx = dest[0]
      @desty = dest[1]
    end
    @angle ||= [@x,@y].angle_to([@destx,@desty])
  end

  def calc args
    if @status == :invincible
      @invincible_timer -= 1
      if @invincible_timer == 0
        @status = :normal
      end
    end
    if @atkcd > 0
      @atkcd -= 1
    end

  end

  def set_anim_state
    # change anim state to new state
    # reset cur_time and fram_index on prev state
  end

  def draw args
    anim = @anims[@anim_state]
    # get next frame of the animation
    frame = anim.frame

    # anim.frame will return nil if anim is over (and anim.loop == false)
    # in that case, return to idle state
    if frame.nil?
      if @anim_state == :die
        @anim_state = :transition
        anim = @anims[@anim_state]
        frame = anim.frame
        #draw transition explosions
        #not sure best way to do that atm
        #could just do it like the other explosions, and 
        #just transition again after some timer elapses
        10.times do |i|
          args.outputs.sprites << []
        end

      elsif @anim_state != :idle
        @anim_state = :idle
        anim = @anims[@anim_state]
        # so here we get first frame of next anim
        frame = anim.frame
      end
    end

    args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: frame,
                             flip_vertically: @flip_v,
                             flip_horizontally: @flip_h}
  end

  def inspect
    "\t==class:#{self.class}==
    \tx: #{@x}
    \ty: #{@y}
    \tcolor: #{@color}\n"
  end

end

class Guy < Ent

  def initialize traits
    super traits
    @anims[:idle] = Anim.new(name: :idle,path: "sprites/archmage/arch-mage+female.png")
    @anims[:idle].loop = true

    @anims[:attack] = Anim.new(name: :attack)#,path: @path)
    (1..2).each do |i|
      @anims[:attack].frames << "sprites/archmage/arch-mage+female-attack-staff-#{i}.png"
    end
    @anims[:attack].duration = @atkspd

    @hitbox = [@x+35,@y+30,15,15,'sprites/border-heart.png']
    @attacks = []
    @attacks << Attack.new(atkframe: 1, dmg: 1)

  end

  def calc args
    @hitbox[0] = @x+35
    @hitbox[1] = @y+30
    if @status == :die
      @anim_state = :die
    end
    super args
    if @anim_state == :attack
      @attacks[0].calc(@anims[anim_state].frame_index, args)
    end


  end

  def attack args
    if atkcd.zero?
      @attacks[0].reset
      @anim_state = :attack
      @atkcd = @atkspd
    end
  end

  def draw args
    args.outputs.labels << [100,680,"anim_state: #{anim_state}",2]
    @anims[anim_state].show_info args
    super args
    args.outputs.sprites << @hitbox
  end

end

class Baddie< Ent

  def initialize traits
    super traits
    @anims[:idle] = Anim.new(name: :idle)
    (1..11).each do |i|
      @anims[:idle].frames << "sprites/necromancer/adept-idle-#{i}.png"
    end
    @anims[:idle].loop = true

    @anims[:attack] = Anim.new(name: :attack)
    (1..3).each do |i|
      @anims[:attack].frames << "sprites/necromancer/adept-magic-#{i}.png"
    end

    @anims[:die] = Anim.new(name: :die)#,path: @path)
    (1..8).each do |i|
      @anims[:die].frames << "sprites/necromancer/adept-die#{i}.png"
    end
    @anims[:die].duration = 10

    @anims[:transition] = Anim.new(name: :die)#,path: @path)
    (5..8).each do |i|
      @anims[:transition].frames << "sprites/icemissile-n-#{i}"
    end
    @anims[:transition].duration = 10

    @max_hp = 3
    @hp = @max_hp
  end

  def draw args
    super args
    args.outputs.solids << [x, y + h,w,30,*Black]
    args.outputs.solids << [x, y + h,w * hp/max_hp ,30,255,0,0]
    args.outputs.borders << [x, y + h,w,30,*Black]
    args.outputs.labels << [x-200,680,"HP: #{hp}/#{max_hp}",2]
    args.outputs.labels << [x-200,650,"Status: #{status}",2]
    args.outputs.labels << [x-300,620,"Sprite: #{@anims[@anim_state].current_sprite}",1]

  end

  def calc args
    if @status == :die
      @anim_state = :die
    end
    super args
    if @anim_state == :attack
      @attacks[0].calc(@anims[anim_state].frame_index, args)
    end


  end

end

class Player < Ent

end

class Bullet < Ent
  attr_accessor :angle

  def calc
    @angle ||= [@x,@y].angle_to([@destx,@desty])
    @x += (@angle.vector_x * @speed)
    @y += (@angle.vector_y * @speed)
    #puts "#{@x}, #{@y}, #{@destx}, #{@desty}, #{@angle}"
  end

  def draw args
    if @angle > 270 || @angle < 90
      flip_v = false
    else
    end
    flip_v = true
    if @angle > 270 || @angle < 90
      flip_h = true
    else
      flip_h = false
    end
    #puts "#{@x}, #{@y}, #{@destx}, #{@desty}, #{@angle}"
    args.outputs.sprites << {x:@x,y:@y,w:@w,h:@w,path: @path, angle: @angle + 30,
                             flip_vertically: flip_v}
  end
end

# apparently yaml support is in the works
# until then i can output yaml just fine, but importing it when needed
# seems impossible
if __FILE__ == $0
  require 'yaml'
  anim = Anim.new({})
  (1..6).each do |i|
    anim.frames << "sprites/siegetrooper-attack-#{i}.png"
  end
  File.open("siegetrooper-attack.yaml",'w') do |f|
    YAML.dump(anim,f)
  end
end


