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
  attr_accessor :x,:y, :w,:h,:speed,:color,:angle, :status, :hp, :hitbox
  attr_accessor :invincible_timer, :invincible_length, :anim_state, :anim,:anims

  def initialize(*traits)
    #p traits
    if traits[0].class == Hash
      @traits = traits[0]
      #puts traits[0][:x]
      @x = traits[0][:x]
      @y = traits[0][:y]
      @w = traits[0][:w]
      @h = traits[0][:h]
      @path = traits[0][:path]
      @color = traits[0][:color]
      @border = traits[0][:border]
      @speed = traits[0][:speed]
      @flip_h = traits[0][:flip_h]
      @flip_v = traits[0][:flip_v]
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
      @anims[:attack] = Anim.new(name: :attack)#,path: @path)
      @anim = @anims[@anim_state]
      

      #@angle ||= 0
      #@hitbox ||= Rect.new(@x,@y,
      #@hitbox = I#
      #elsif traits.size > 1      # was going to give option to init as array
    end
    @w ||= 100
    @h ||= 100
    @path ||= 'sprites/misc/dragon-0.png'
    @anims ||= Anim.new(name: :idle,path: @path)
    @color ||= Green
    @border ||= Darkblue
  end
  def rect
    [@x,@y,@w,@h]
  end

  def set_dest *dest
    puts dest
    if dest[0].class == Array
      @destx, @desty = dest[0]
    else
      @destx = dest[0]
      @desty = dest[1]
    end
    @angle ||= [@x,@y].angle_to([@destx,@desty])
  end

  def calc
    @hitbox = [@x+35,@y+30,15,15,'sprites/border-heart.png']
    if @status == :invincible
      @invincible_timer -= 1
      if @invincible_timer == 0
        @status = :normal
      end
    end

  end

  def draw args
    args.outputs.labels << [100,680,"anim_state: #{@anim_state}",2]
    if @anim_state == :idle
      draw_old args
      return
    end
    @anim = @anims[@anim_state]
    @anim.cur_time += 1
    if @anim.cur_time == @anim.max_time
      @anim.reset
      @anim_state = :idle
    end
    if @anim_state == :idle
      draw_old args
      return
    end
    if @anim.cur_time != 0 && anim.cur_time % @anim.timesperframe == 0
      @anim.frame_index += 1
    end
    args.outputs.labels << [100,650,"frame_index: #{@anim.frame_index}",2]
    args.outputs.labels << [100,620,"cur_time: #{@anim.cur_time}",2]
    args.outputs.labels << [100,590,"max_time: #{@anim.max_time}",2]
    puts @anim.frame_index

    args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: @anim.frames[@anim.frame_index],
                             flip_vertically: @flip_v,
                             flip_horizontally: @flip_h}
    args.outputs.sprites << @hitbox

  end

  def draw_old args
    args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: @path,
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
  attr_accessor :path, :max_time,:cur_time,:frame_time,:timesperframe,:cur_frame,:frames
  attr_accessor :frame_index
  def initialize(args)
    @path = args[:path]
    @cur_time =0
    #@frame_time = 3
    @timesperframe = 4
    @frames = []
    (1..6).each do |i|
      @frames << "sprites/siegetrooper-attack-#{i}.png"
    end
    @max_time = @timesperframe * @frames.size
    @frame_index = 0
  end

  def reset
    @frame_index = 0
    @cur_time = 0
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


