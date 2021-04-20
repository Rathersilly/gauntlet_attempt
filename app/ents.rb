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

class Ent
  attr_accessor :x,:y, :w,:h,:speed,:color,:angle
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
      @speed ||= 10
      #@angle ||= 0
      
      #@hitbox ||= Rect.new(@x,@y,
      #@hitbox = I#
      
    #elsif traits.size > 1

    end

    @w ||= 100
    @h ||= 100
    @path ||= 'sprites/misc/dragon-0.png'
    @color ||= Green
    @border ||= Darkblue
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
    @hitbox = [@x+20,@y+20,40,40,'sprites/hexagon/black.png']

  end

  def draw args
    if @angle > 270 || @angle < 90
      flip_v = false
    else
      flip_v = true
    end
    args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: @path, flip_v: flip_v}
    args.outputs.sprites << @hitbox

  end

  def inspect
    "\t==class:#{self.class}==
    \tx: #{@x}
    \ty: #{@y}
    \tcolor: #{@color}\n"
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
    args.outputs.sprites << {x:@x,y:@y,w:50,h:50,path: @path, angle: @angle, flip_vertically: flip_v}
  end
end
