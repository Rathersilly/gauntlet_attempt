module AnimationSystem

  def do_animation
    #calc_sprites

    render_background
    render_sprites
    #render_labels
  end

  def calc_sprites
    state.anims.each_with_index  do |anim, ent|

      anim.cur_time += 1

      if anim.cur_time == anim.frame_dur
        anim.cur_time = 0
        anim.frame_index += 1

        if anim.frame_index == anim.frames.size
          if anim.loop == true
            reset_anim anim
          else
            finish_anim anim
          end

        end
      end
      state.sprites[ent] = anim.to_h
    end

    Tools.megainspect state.sprites
  end

  def calc_sprite anim
    anim.cur_time += 1

    if anim.cur_time == anim.frame_dur
      anim.cur_time = 0
      anim.frame_index += 1

      if anim.frame_index == anim.frames.size
        if anim.loop == true
          reset_anim anim
        else
          finish_anim anim
        end

      end
    end
    anim.to_h
  end

  def render_background
    outputs.background_color = Yellow
  end

  def render_sprites
    outputs.sprites << state.xforms.map.with_index do |xf, i|
      xf.merge(calc_sprite(state.anims[i]))
    end

    # state.spell_anims.each do |anim|
    #   next if anim.nil? || anim.state == :done
    #   anim.render args 
    #   outputs.sprites << [**xform.to_h, **sprite.to_h]
    # end

  end

  def render_labels
    outputs.labels << [10,700, "#{gtk.current_framerate.round}"]
  end
  
  ##### anim controls #####
  # possibly should be moved but they are ok here

  def reset_anim anim
    anim.state       = :play
    anim.cur_time    = 0
    anim.frame_index = 0
  end

  def finish_anim anim
    reset_anim anim
    anim.state = :done
    if state.behaviors.any? { |b| b.ent == anim.ent }
      state.behavior_signals << BehaviorSignal.new(ent: ent,
                                                        type: Anim,
                                                        state: :done,
                                                        info: anim.name)
    end
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

end
