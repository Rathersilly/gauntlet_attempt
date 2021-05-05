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

# Ent needs x,y,anything else?
class Ent
  attr_accessor :x,:y, :w,:h, :statue
  def initialize args

    @x = args[:x]
    @y = args[:y]
    @w = args[:w]
    @w ||= 100
    @h = args[:h]
    @h ||= 100
  end
  def be thing
    self.class.send(:prepend, thing)
  end


end

# just a teensy amount of inheritance; mostly modules from now on
# Guy is moveable and has animations
# need dependent: destroy like rails i think
class Mob < Ent
  # mob has animations? always?
  # mob has a draw function that will be drawn if no anims
  # anim will be prepended
  # has a team?
  # has hp
  # has state
  attr_accessor :state, :speed, :atkspd
  def initialize args
    super args
    @state = :idle
    @speed = args[:speed]
    #@speed ||= 6
    @status ||= :normal
    @atkspd = args[:atkspeed]
    @atkspd ||= 30
  end
  def calc args
  end

end
class Hero < Mob
  def initialize args
    super args
  end
end

module Animated
  attr_accessor :anims, :cur
  @cur_anim = :idle
  @anims = {}
  def calc args
    puts "Animated calc"
    super
    # get the right frame of the right anim
    puts anims
    if @anims[@cur_anim].update.nil?
      @cur_anim = :idle
    end
  end
  def prepended m
    m.anims ||= {} 
  end

end

module Visible
  attr_accessor :path
  def initialize args
    @path = 'sprites/sylph.png'
  end
  def draw args
    args.outputs.sprites << [x,y,w,h,path]
  end

end

module Moveable
  
end
