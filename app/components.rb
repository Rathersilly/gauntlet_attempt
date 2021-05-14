class Component
  attr_accessor :ent, :container

  def initialize **opts
    @ent          = opts[:ent]         || nil
    @container    = opts[:container]   || nil
  end

end

class Xform < Component
  attr_accessor :x,:y, :w, :h
  
  def initialize **opts
    super
    @x = opts[:x]  || 0
    @y = opts[:y]  || 0
    @w = opts[:w]  || 0
    @h = opts[:h]  || 0
  end
  def to_h
    {x: @x,y:@y,w: @w, h: @h}
  end

end

class Anim < Component
  attr_accessor :name, :ent, :angle, :path, :duration, :loop, :state
  attr_accessor :frames, :up, :upframes
  attr_accessor :flip_horizontally, :flip_vertically
  attr_accessor :cur_time, :frame_dur, :frame_index, :spell

  def initialize **opts
    super
    @flip_horizontally      = opts[:flip_horizontally]     || false
    @flip_vertically        = opts[:flip_vertically]       || false

    @name         = opts[:name]        || nil
    @ent          = opts[:ent]         || nil
    @angle        = opts[:angle]       || 0
    @loop         = opts[:loop]        || false
    @duration     = opts[:duration]    || 60
    
    # possible states: play, stop, pause, done
    @state        = opts[:state]       || :play
    @up           = opts[:up]          || false
    @frames       = []
    @upframes     = []    # for animations with 4 directions (incl flip)
    @frame_index  = 0
    @cur_time     = 0
    @spell        = false
  end

  def to_h
    { path: @frames[@frame_index],
      angle: @angle,
      flip_horizontally: @flip_horizontally,
      flip_vertically: @flip_vertically
    }
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
  attr_accessor :name, :ent, :args, :container
  def initialize(**opts)
    @ent          = opts[:ent]         || nil
    @name         = opts[:name]        || nil
    @default      = opts[:default]     || false
    post_initialize opts
  end

  def post_initialize opts
    # to be overridden if needed in subclasses
  end

  def known_anims ent, name
    args.state.known_anims[ent][name].dup
  end

  # args as first arg would be more consistent, but who could resist?
  def handle bs, args
    puts "HANDLING BEHAVIOR SIGNAL"
      Tools.megainspect bs

    if bs.type == Anim && bs.state == :done
      puts "SUPER HANDLING BS"
      Tools.megainspect bs
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

  def set_dir args, dest_vector
    # expect dest_vector = [x,y]
    xform = @container.xforms[@ent]
    x = dest_vector[0] - xform.x
    y = dest_vector[1] - xform.y
    norm = Tools.normalize([x,y])
    @dirx = norm[0]
    @diry = norm[1]
  end

  def set_dest args, dest_vector
    @dest = dest_vector
  end

end

class BehaviorSignal < Component
  # when an animation finishes, it sets it state to :done (so it is cleaned up)
  # and places a BehaviorSignal instance in state.behavior_signals
  # which is looped through in the behavior system
  attr_accessor :ent, :type, :state, :info, :handled, :container

  # types of BSignals: anim_finished

  def initialize(**opts)
    puts "BEHAVIOR SIGNAL CREATED"
    # type = :anim_done
    # info = eg anim name
    @ent          = opts[:ent]         || nil
    @type         = opts[:type]        || nil
    @state        = opts[:state]       || nil
    @info         = opts[:info]        || nil
    @spell         = opts[:spell]      || nil
    @handled      = opts[:handled]     || false
  end

end
