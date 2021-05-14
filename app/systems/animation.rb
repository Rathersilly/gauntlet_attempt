module AnimationSystem

  def do_animation
    # puts "ANIMATING"

    render_background
    # puts "3333333333333333"
    # Tools.megainspect state.anims[3]
    render_mobs
    render_spells
    render_labels
  end

  # replaced with cacl_sprite in the render_sprites function
  # def calc_sprites
  #   state.anims.each_with_index  do |anim, ent|

  #     anim.cur_time += 1

  #     if anim.cur_time == anim.frame_dur
  #       anim.cur_time = 0
  #       anim.frame_index += 1

  #       if anim.frame_index == anim.frames.size
  #         if anim.loop == true
  #           reset_anim anim
  #         else
  #           finish_anim anim
  #         end

  #       end
  #     end
  #     state.sprites[ent] = anim.to_h
  #   end

  #   Tools.megainspect state.sprites
  # end

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

  def render_mobs
    outputs.sprites << state.mobs.xforms.map.with_index do |xf, i|

      anim = state.mobs.anims[i]
      # puts "RENDERING"
      # p xf.to_h
      # p i
      # p anim
      
      if anim && anim.state == :play
        xf.to_h.merge(calc_sprite(state.mobs.anims[i]))
      else
        nil
      end
    end

  end

  def render_spells
    outputs.sprites << state.spells.xforms.map.with_index do |xf, i|

      anim = state.spells.anims[i]
      if anim && anim.state == :play
        xf.to_h.merge(calc_sprite(state.spells.anims[i]))
      else
        nil
      end
    end
  end

  def render_labels
    outputs.labels << [100,40, "#{state.mobs.anims[1].cur_time}"]
    outputs.labels << [100,60, "#{state.mobs.anims[1].frame_dur}"]
    outputs.labels << [100,80, "#{state.mobs.anims[1].frame_index}"]
    outputs.labels << [100,100, "#{state.mobs.anims[1].duration}"]
  end

  ##### anim controls #####
  # possibly should be moved but they are ok here

  def reset_anim anim
    anim.state       = :play
    anim.cur_time    = 0
    anim.frame_index = 0
  end

  def finish_anim anim
    puts "FINISHING ANIM"
    Tools.megainspect anim
    reset_anim anim
    anim.state = :done
    if anim.container.behaviors.any? { |b| b.ent == anim.ent }
      anim.container.behavior_signals << BehaviorSignal.new(ent: anim.ent,
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
