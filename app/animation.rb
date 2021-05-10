# considering moving excess functions from Anim to here
class AnimTemplate
  attr_accessor :name, :ent, :angle, :path, :frames, :up,  :upframes, :duration, :loop, :state
  attr_accessor :flip_horizontally, :flip_vertically
  attr_accessor :cur_time, :frame_dur, :frame_index


  class << self
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
end

module Animation
  def calc_sprites
    state.anims.each_with_index  do |anim, ent|

      anim.cur_time += 1

      if anim.cur_time == anim.frame_dur
        anim.cur_time = 0
        anim.frame_index += 1

        if anim.frame_index == anim.frames.size
          if anim.loop == true
            reset
          else
            finish_anim anim
            if args.state.behaviors.any? { |b| b.ent == ent }
              args.state.behavior_signals << BehaviorSignal.new(ent: ent,
                                                                type: Anim,
                                                                state: :done,
                                                                info: anim.name)
            end

          end

        end
      end
      state.sprites[ent] = anim.to_h
    end

  end
  
  def reset_anim anim
    anim.state = :play
    anim.cur_time = 0
    anim.frame_index = 0
  end

  def finish_anim anim
    reset_anim anim
    anim.state = :done
  end

  def play anim
    anim.state = :play
  end

  def stop anim
    reset
    anim.state = :stop
  end

  def pause anim
    anim.state = :pause
  end

  def render

    state.sprites.each do |sprite|
      next if sprite.nil?
      # args.outputs.sprites << [**xform.to_h, **sprite.to_h]
      args.outputs.sprites << xform.to_h.merge(sprite)
    end

    # state.spell_anims.each do |anim|
    #   next if anim.nil? || anim.state == :done
    #   anim.render args 
    #   args.outputs.sprites << [**xform.to_h, **sprite.to_h]
    # end
    
  end

  def render_background
    outputs.background_color = Yellow
  end
  def render_labels
    outputs.labels << [10,700, "#{args.gtk.current_framerate.round}"]
  end

end
