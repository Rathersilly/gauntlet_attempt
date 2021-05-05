#effects class

# can be created, and can be run.
# has container of anims, each of which can have offset coords, start time, duration
# i think i just gonna add those to anim class
class Effect
  def initialize(traits)
    @traits = traits
    @x = traits[:x]
    @y = traits[:y]
    @w = traits[:w]
    @w ||= 100
    @h = traits[:h]
    @h ||= 100
    @anims = []
    anim = Anim.new(name: :explode)
    (5..7).each do |i|
      anim.frames << "sprites/icemissile-n-#{i}"
    end
    anim.duration = 20
    @anims << anim
    @state = :off
  end

  def add_anim(anim,frame)
  end

  def run args
    args.active_effects << self
  end

  def draw
    # endflag is to check if all animations are finished drawing
    endflag = false
    @anims.each do |anim|

      frame = anim.frame
      next unless frame
      endflag = true
      args.outputs.sprites << {x:@x,y:@y,w:@h,h: @h,path: frame,
                               flip_vertically: @flip_v,
                               flip_horizontally: @flip_h}
    end
    if endflag == true
      @state = :off
      reset
    end
  end

  def reset
  end



end

e = Effect.new

