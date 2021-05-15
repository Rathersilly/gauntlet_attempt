class Animation < System

  def initialize
    super
    @view << Anim
    @view << Frame
  end

  def tick args, reg
    super
    # puts "ANIMATION TICK"
    # @registry.inspect
    calc_sprites args
  end

  def calc_sprites args
    # just update frame_index
    @registry.anims.each.with_index do |anim, ent|
      # puts "ANIM"
      # Tools.megainspect anim
      # puts "TO HASH"
      # p anim.to_h
      # p @registry.anims
      # p @registry.frames
      # p @ent

      anim.cur_time += 1

      if anim.cur_time == anim.frame_duration
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
      @registry.frames[ent] = anim.to_h

    end
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
