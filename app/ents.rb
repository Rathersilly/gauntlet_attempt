# This class will contain everything needed to draw a to outputs
# EXCEPT sprite specific things
# oh man, i think this needs to be usable as a hash for
# args.outputs to be able to use it.  might be great opportunity
# to use forwardable or that other thing.

# actually, this class might not even be needed:
# ie args.state.xforms[ent] = [1,1,1,1]
class Xform
  attr_accessor :ent, :x,:y, :w, :h, :angle, :r ,:g, :b, :a
  def initialize(**opts)
    @ent        = opts[:ent]
    @x          = opts[:x]
    @y          = opts[:y]
    @w          = opts[:w]       || 100
    @h          = opts[:h]       || 100
    @color      = opts[:color]
  end

  def to_h
    {x: @x,y:@y,w:@w,h:@h}
  end
  def to_a
    [@x,@y,@w,@h]
  end
end

class Anim
  attr_accessor :name, :ent, :angle, :path, :frames, :duration, :loop, :state
  def initialize(**opts)
    # possible states: play, stop, pause, done
    @name         = opts[:name]        || nil
    @ent          = opts[:ent]         || nil
    @angle        = opts[:angle]       || 0
    @loop         = opts[:loop]        || false
    @duration     = opts[:duration]    || 60
    @state        = opts[:state]       || :play
    @frames       = []
    @frame_index  = 0
    @cur_time = 0
  end

  def play
    @state = :play
  end
  def stop
    @state = :stop
    reset
  end
  def pause
    @state = :pause
  end
  def done
    @state = :done
  end
  def reset
    @cur_time = 0
    @frame_index = 0
  end

  def << path
    @frames << path
    @frame_dur = (@duration / @frames.size).round
  end

  def duration= dur
    @duration = dur
    @frame_dur = (@duration / @frames.size).round
  end

  def render args
    if @state != :play
      return 
    end
    # yeah there's no way this has good performance lol
    # would have to make custom data structure?
    xform = args.state.xforms.find { |x| x.ent == @ent }
    # args.outputs.sprites << xform.to_h.merge(path: @frames[@frame_index], angle: @angle)
    #
    # uhh or could just use array
    args.outputs.sprites << [*args.state.xforms[@ent].to_a,@frames[@frame_index], @angle]
    @cur_time += 1
    if @cur_time == @frame_dur
      @cur_time = 0
      @frame_index += 1
      if @frame_index == @frames.size
        @frame_index = 0
      end
    end
  end

  def inspect
    puts "*****Animation*****"
    puts "name: #{@name}"
    puts "ent: #{@ent}"
    #puts "frames: #{@frames}"
    puts "*******************"
  end
end

class Behavior
  # does behavior know about all its anims? or just loop through them as needed and select
  # the ones with the same ent
  attr_accessor :name, :ent
  def initialize(**opts)
    @name         = opts[:name]        || nil
    @ent          = opts[:ent]         || nil
  end



end
# Ent is a tiny container that links components
# honestly though this just needs to be a unique integer
class Ent 
  def initialize(**opts)
  end
end
