# This class will contain everything needed to draw a to outputs
# EXCEPT sprite specific things
# oh man, i think this needs to be usable as a hash for
# args.outputs to be able to use it.  might be great opportunity
# to use forwardable or that other thing.

# Ent is a tiny container that links components
# honestly though this just needs to be a unique integer
class Ent 
  def new_entity_id args
    args.state.entity_id += 1
  end

  def new_tent_id args
    args.state.tent_id += 1
  end

  def initialize(**opts)
  end

end

# actually, this class might not even be needed:
# ie args.state.xforms[ent] = [1,1,1,1]
class Xform < Ent
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

class Anim < Ent
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
    reset
    @state = :stop
  end
  def pause
    @state = :pause
  end
  def done
    reset
    @state = :done
  end
  def reset
    @state = :play
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
        if @loop == true
          reset
        else
          args.state.behavior_signals << BehaviorSignal.new(ent: @ent,
                                                            type: Anim,
                                                            state: :done,
                                                            info: @name)

          done
        end

      end
    end
  end

  def inspect
    puts "*****Animation*****"
    print "\tname: #{@name}" + "\tent: #{@ent}" + "\tstate: #{@state}\n"
  end
end

class Behavior < Ent
  # does behavior know about all its anims? or just loop through them as needed and select
  # the ones with the same ent

  # the current plan: add methods here to singleton class.  But have templates for things
  # that need to be repeated. or actually subclasses would work I think.
  attr_accessor :name, :ent, :args
  def initialize(**opts)
    @ent          = opts[:ent]         || nil
    @name         = opts[:name]        || nil
    @default      = opts[:default]     || false
  end

  def known_anims ent, name
    args.state.known_anims[ent][name].dup
  end
  
  def handle bs, args
    puts "HANDLING BEHAVIOR SIGNAL"
    p bs
    if bs.type == Anim && bs.state == :done
      default_anim args if methods.include?(:default_anim)
    end

  end

end

class BehaviorSignal
  # when an animation finishes, it sets it state to :done (so it is cleaned up)
  # and places a BehaviorSignal instance in state.behavior_signals
  # which is looped through in the behavior system
  attr_accessor :ent, :type, :state, :info

  # types of BSignals: anim_finished

  def initialize(**opts)
    # type = :anim_done
    # info = eg anim name
    @ent          = opts[:ent]         || nil
    @type         = opts[:type]        || nil
    @state        = opts[:state]       || nil
    @info         = opts[:info]        || nil
  end

  def inspect
    puts "ent: #{@ent}, #{@type}, #{@state}"
    super
  end
end

