class Frame < Component
  attr_accessor :path, :angle
  attr_accessor :flip_horizontally, :flip_vertically
end

class Anim < Component
  #TODO surely these are not all necessary
  attr_accessor :name, :ent, :angle, :duration, :end_action, :state, :color
  attr_accessor :frames, :up, :upframes
  attr_accessor :flip_horizontally, :flip_vertically
  attr_accessor :cur_time, :frame_duration, :frame_index

  # @when_over options: nil, :loop, :stay
  def initialize **opts
    super
    @flip_horizontally      = opts[:flip_horizontally]     || false
    @flip_vertically        = opts[:flip_vertically]       || false

    @name         = opts[:name]        || nil
    @ent          = opts[:ent]         || nil
    @angle        = opts[:angle]       || 0
    @end_action   = opts[:end_action]  || nil 
    @duration     = opts[:duration]    || 60
    @color        = opts[:color]       || nil

    # possible states: play, stop, pause, done
    @state        = opts[:state]       || :play
    @up           = opts[:up]          || false
    @frames       = []
    @upframes     = []    # for animations with 4 directions (incl flip)
    @frame_index  = 0
    @cur_time     = 0
  end

  def to_h
    if !@up
      { path: @frames[@frame_index],
        angle: @angle,
        flip_horizontally: @flip_horizontally,
        flip_vertically: @flip_vertically
      }
    else
      { path: @upframes[@frame_index],
        angle: @angle,
        flip_horizontally: @flip_horizontally,
        flip_vertically: @flip_vertically
      }
    end
  end

  def << path
    @frames << path
    @frame_duration = (@duration / @frames.size).round
  end

  def add_frame path
    @frames << path
    @frame_duration = (@duration / @frames.size).round
  end

  def add_upframe path
    @upframes << path
    @frame_duration = (@duration / @upframes.size).round
  end

  def duration= dur
    @duration = dur
    @frame_duration = (@duration / @frames.size).round
  end

end

