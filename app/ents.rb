class Square
  attr_accessor :x,:y, :color
  def initialize(*traits)
    puts "Creating Square"
    p traits
    puts Darkblue
    if traits[0].class == Hash
      puts traits[0][:position][:x]
      @x = traits[0][:position][:x]
      @y = traits[0][:position][:y]
      @w = traits[0][:position][:w]
      @h = traits[0][:position][:h]
      @color = traits[0][:color]
      @border = traits[0][:border]
    elsif traits.size > 2
      @x,@y,@w,@h,@color = traits
    end
    @w ||= Gsize
    @h ||= Gsize
    # 1 is gonna be short for Gsize for brevity
    @w = Gsize if @w == 1
    @h = Gsize if @h == 1
    @color ||= Green
    @border ||= Darkblue
  end

  def gridxy
    [@x,@y]
  end
  def realxy
    [@x*Gsize,@y*Gsize]
  end

  def draw args
    args.outputs.solids << [@x*Gsize,@y*Gsize,@w,@h,*@color]
    args.outputs.borders<< [@x*Gsize,@y*Gsize,@w,@h,*@border]
  end
  def inspect
    "\t==class:#{self.class}==
    \tx: #{@x}
    \ty: #{@y}
    \tcolor: #{@color}\n"
  end

end
class Block < Square

end
class Guy < Square
  attr_accessor :sprite, :name
  def initialize(*traits)
    super traits[0]
    @sprite = traits[0][:sprite]
    @name = %w[alice bob carlos dierdre].sample
  end
  def draw args
    args.outputs.sprites << [@x*Gsize,@y*Gsize,@w,@h,@sprite]
    args.outputs.borders << [@x*Gsize,@y*Gsize,@w,@h,*@border]
  end

end

class Control < Square

end

class TeamContainerafdsfdsfds
  attr_accessor :teams
  def initialize
    @teams = []
  end
  def << new_team
    @teams << new_team
  end

  def method_missing m
    @teams.find {|team| team.name.downcase == m.to_s}
  end
  def first
    @teams.first
  end
  def all
    @teams
  end
  def empty?
    @teams.empty?
  end
end
class TeamContainer < Array
  def method_missing m
    find {|team| team.name.downcase == m.to_s}
  end
end

class Team
  attr_accessor :name, :members
  def initialize(name, color = Red)
    @members = []
    @name = name
    @color = color 
  end
  def << new_member
    @members << new_member
  end


end


class Ent
  attr_accessor :x,:y, :destx,:desty,:speed
  def initialize(x,y,image =  'sprites/circle/blue.png', destx=nil,desty=nil,speed=4)
    @image = image
    @x = x
    @y = y
    @speed = speed

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
  end

  def draw args
    args.outputs.sprites << [x,y,20,20,@image]

  end
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
    args.outputs.sprites << [@x,@y,50,50,@image]
  end
end

