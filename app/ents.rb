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
  attr_accessor :x,:y, :w,:h,:speed,:color,:angle, :status, :hp, :hitbox, :angle
  attr_accessor :invincible_timer, :invincible_length, :anim_state, :anim,:anims

  def initialize(traits)
    #p traits
    @traits = traits
    @x = traits[:x]
    @y = traits[:y]
    @w = traits[:w]
    @h = traits[:h]
    @path = traits[:path]
    @color = traits[:color]
    @border = traits[:border]
    @speed = traits[:speed]
    @flip_h = traits[:flip_h]
    @flip_v = traits[:flip_v]
    @angle = traits[:angle]
    @speed ||= 6
    @status ||= :normal
    @invincible_length ||= 60
    @invincible_timer ||=0
    @hp               ||= 10
    @flip_v           ||= false
    @flip_h           ||= false

    @anim_state         ||= :idle
    @anims            ||= {}
    @anims[:idle] = Anim.new(name: :idle,path: @path)
    @anims[:idle].loop = true
    @anims[:attack] = Anim.new(name: :attack)#,path: @path)

    (1..6).each do |i|
      @anims[:attack].frames << "sprites/siegetrooper-attack-#{i}.png"
    end


    #@angle ||= 0
    #@hitbox ||= Rect.new(@x,@y,
    #@hitbox = I#
    #elsif traits.size > 1      # was going to give option to init as array
    @w ||= 100
    @h ||= 100
    @path ||= 'sprites/misc/dragon-0.png'
    @anims ||= Anim.new(name: :idle,path: @path)
    @color ||= Green
    @border ||= Darkblue
    @hitbox = [@x+35,@y+30,15,15,'sprites/border-heart.png']
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

  def calc
    @hitbox[0] = @x+35
    @hitbox[1] = @y+30
    if @status == :invincible
      @invincible_timer -= 1
      if @invincible_timer == 0
        @status = :normal
      end
    end

  end

  def set_anim_state
    # change anim state to new state
    # reset cur_time and fram_index on prev state
  end

  def draw args

    args.outputs.labels << [100,680,"anim_state: #{@anim_state}",2]

    anim = @anims[@anim_state]
    anim.show_info args
    frame = anim.frame

    if @anim_state != :idle && !(frame)
      @anim_state = :idle
      anim = @anims[@anim_state]
      frame = anim.frame
    end

    args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: frame,
                             flip_vertically: @flip_v,
                             flip_horizontally: @flip_h}
    args.outputs.sprites << @hitbox
  end

  def inspect
    "\t==class:#{self.class}==
    \tx: #{@x}
    \ty: #{@y}
    \tcolor: #{@color}\n"
  end

end

class Anim
  attr_accessor :path, :cur_frame,:frames, :loop
  attr_accessor :frame_index, :name, :frames_per_sprite,:max_frames

  def initialize(args)
    @name = args[:name]
    @frames = []

    @path = args[:path]
    if @path
      @frames << @path
    end
    @cur_frame = 0
    @frames_per_sprite = 10
    @max_frames = @frames_per_sprite * @frames.size
    @frame_index = 0
    @loop = false

  end

  def frame
    # returns the frame to be drawn (in Ent class)
    if frames.size == 1
      return frames[0]
    end

    # incrementing cur_time first, so that can check modulsu without worrying about 0 % n
    @cur_frame += 1

    # handle if cur = max - return nil or reset?
    if cur_frame > max_frames
    end

    if  cur_frame % frames_per_sprite == 0
      # if this says frame_index (without @), it doesnt update
      @frame_index += 1
    end
    
    # good place to check bounds
    if @frame_index > @frames.size - 1
      if @loop == true
        reset
      else
        reset
        return nil
      end
    end

    # return the sprite to use
    #dbinspect
    return frames[frame_index]
  end

  def show_info args
    args.outputs.labels << [100,650,"frame_index: #{frame_index}",2]
    args.outputs.labels << [100,620,"cur_frame: #{cur_frame}",2]
    args.outputs.labels << [100,590,"max_frame: #{max_frames}",2]
    args.outputs.labels << [100,560,"path: #{frames[frame_index]}",2]
  end

  def reset
    @frame_index = 0
    @cur_frame = 0
  end 

  def dbinspect
    instance_variables.each do |var|
      puts "#{var}:\t\t#{instance_variable_get(var)}"
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
      flip_v = true
    end
    if @angle > 270 || @angle < 90
      flip_h = true
    else
      flip_h = false
    end
    #puts "#{@x}, #{@y}, #{@destx}, #{@desty}, #{@angle}"
    #args.outputs.sprites << [@x,@y,50,50,@path, @angle]
    args.outputs.sprites << {x:@x,y:@y,w:50,h:50,path: @path, angle: @angle,
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


