# This class will contain everything needed to draw a to outputs
# EXCEPT sprite specific things
# oh man, i think this needs to be usable as a hash for
# args.outputs to be able to use it.  might be great opportunity
# to use forwardable or that other thing.

# Not sure this class even needs to be a thing - nice to have components
# documented as such though
class Component
end

# actually, this class might not even be needed:
# ie args.state.xforms[ent] = [1,1,1,1]
class Xform < Component
  attr_accessor :ent, :x,:y, :w, :h, :angle, :r ,:g, :b, :a
  def initialize(**opts)
    @ent        = opts[:ent]
    @x          = opts[:x]
    @y          = opts[:y]
    @w          = opts[:w]       || 100
    @h          = opts[:h]       || 100
    @color      = opts[:color]
  end

  # TODO: refactor out these functions - only need the data
  def to_h
    {x: @x,y:@y,w:@w,h:@h}
  end
  def to_a
    [@x,@y,@w,@h]
  end
end

# lmao there's a hell of a lot of logic here for a so-called component
# actually its not so bad - its all in the render function, which can be moved easily
class Anim < Component
  attr_accessor :name, :ent, :angle, :path, :frames, :up,  :upframes, :duration, :loop, :state
  attr_accessor :flip_horizontally, :flip_vertically
  # this line can be commented out - these should be private - uncomment for debug
  attr_accessor :cur_time, :frame_dur, :frame_index

  def initialize(**opts)
    # possible states: play, stop, pause, done
    @name         = opts[:name]        || nil
    @ent          = opts[:ent]         || nil
    @angle        = opts[:angle]       || 0
    @loop         = opts[:loop]        || false
    @duration     = opts[:duration]    || 60
    @state        = opts[:state]       || :play
    @up           = opts[:up]          || false
    @flip_horizontally      = opts[:flip_horizontally]     || false
    @flip_vertically        = opts[:flip_vertically]       || false
    @frames       = []
    @upframes     = []    # for animations with 4 directions (incl flip)
    @frame_index  = 0
    @cur_time     = 0
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

  def add_frame path
    @frames << path
    @frame_dur = (@duration / @frames.size).round
  end

  def add_upframe path
    @upframes << path
    @frame_dur = (@duration / @upframes.size).round
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
    xform = args.state.xforms[@ent]
    # args.outputs.sprites << xform.to_h.merge(path: @frames[@frame_index], angle: @angle)
    #
    # uhh or could just use array

    #args.outputs.sprites << [*args.state.xforms[@ent].to_a,@frames[@frame_index], @angle]
    #args.outputs.sprites << [*xform.to_a,@frames[@frame_index], @angle]
    if up == false
      args.outputs.sprites << [**xform.to_h, path: @frames[@frame_index],
                               angle: @angle,
                               flip_horizontally: @flip_horizontally,
                               flip_vertically: @flip_vertically]
    else
      args.outputs.sprites << [**xform.to_h, path: @upframes[@frame_index],
                               angle: @angle,
                               flip_horizontally: @flip_horizontally,
                               flip_vertically: @flip_vertically]
    end

    @cur_time += 1
    if @cur_time == @frame_dur
      @cur_time = 0
      @frame_index += 1
      if @frame_index == @frames.size
        if @loop == true
          reset
        else
          if args.state.behaviors.any? { |b| b.ent == @ent }
            args.state.behavior_signals << BehaviorSignal.new(ent: @ent,
                                                              type: Anim,
                                                              state: :done,
                                                              info: @name)
          end

          done
        end

      end
    end
  end

  def megainspect
    puts "*****Animation*****"
    print "\tname: #{@name}" + "\tent: #{@ent}" + "\tstate: #{@state}\n"
    p @frames
    p @upframes
  end
end

# again, logic can be moved out of here (mainly the set_dir function)
# every unnecessary function (or anything) defeats the point of components.
# like maybe even move the inspect function to some sort of helper class
# actually this needs massive refactor
class Behavior < Component
  # does behavior know about all its anims? or just loop through them as needed and select
  # the ones with the same ent

  # the current plan: add methods here to singleton class.  But have templates for things
  # that need to be repeated. or actually subclasses would work I think.
  attr_accessor :name, :ent, :args
  def initialize(**opts)
    @ent          = opts[:ent]         || nil
    @name         = opts[:name]        || nil
    @default      = opts[:default]     || false
    post_initialize opts
  end

  def post_initialize opts
    # to be overridden if needed in subclasses
    # Sandi Metz taught me this but don't blame her if its wrong
  end

  def known_anims ent, name
    args.state.known_anims[ent][name].dup
  end
  
  # i know args first would be more consistent, but i can't help myself
  def handle bs, args
    puts "HANDLING BEHAVIOR SIGNAL"
    bs.megainspect

    if bs.type == Anim && bs.state == :done

      default_anim args if methods.include?(:default_anim)
    end
    bs.handled = true
  end

  def add_attribute name, value, access = true
    instance_variable_set("@#{name}", value)
    if access == true
      singleton_class.class_eval { attr_accessor name}
    end
  end

  def set_dir  args, dest_vector
    # expect [x,y]
    xform = args.state.xforms.find { |xform| xform.ent == @ent }
    x = dest_vector[0] - xform.x
    y = dest_vector[1] - xform.y
    norm = Tools.normalize([x,y])
    @dirx = norm[0]
    @diry = norm[1]
  end

end

class BehaviorSignal < Component
  # when an animation finishes, it sets it state to :done (so it is cleaned up)
  # and places a BehaviorSignal instance in state.behavior_signals
  # which is looped through in the behavior system
  attr_accessor :ent, :type, :state, :info, :handled

  # types of BSignals: anim_finished

  def initialize(**opts)
    puts "BEHAVIOR SIGNAL CREATED"
    # type = :anim_done
    # info = eg anim name
    @ent          = opts[:ent]         || nil
    @type         = opts[:type]        || nil
    @state        = opts[:state]       || nil
    @info         = opts[:info]        || nil
    @handled      = opts[:handled]     || false
  end

  def megainspect
    puts "ent: #{@ent}, #{@type}, #{@state}"
  end
end

