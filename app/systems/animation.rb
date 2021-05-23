class AnimSystem < System

  def initialize
    super
    @writes += [Anim, Frame, BehaviorGroup, BehaviorSignal]
  end

  def tick args, reg
    super
    calc_sprites args
  end

  def calc_sprites args
    # just update frame_index
    # puts "CALC SPRITES".green
    # p @view
    # puts "CALC SPRITES".brown
    # p @view[Anim]
    @view[Anim].each.with_index do |anim, ent|
      # puts "ANIM"
      # Tools.megainspect anim
      # puts "TO HASH"
      # p anim.to_h
      # p @view.anims
      # p @view.frames
      # p @ent
      next if anim.nil?
      if anim.state != :play
        @view[Frame][ent] = nil
      else
        anim.cur_time += 1

        if anim.cur_time == anim.frame_duration
          anim.cur_time = 0
          anim.frame_index += 1
          if anim.frame_index == anim.frames.size
            if anim.end_action == :loop
              reset_anim anim
            elsif anim.end_action == :stay
              anim.frame_index -= 1
            else
              finish_anim anim
            end
          end
        end

        @view[Frame][ent] = anim.to_h
      end
    end
  end


  ##### anim controls #####
  # possibly should be moved but they are ok here for now

  def reset_anim anim
    anim.state       = :play
    anim.cur_time    = 0
    anim.frame_index = 0
  end

  def finish_anim anim
    # puts "FINISHING ANIM"
    # Tools.megainspect anim

    reset_anim anim
    anim.state = :done
    if anim.container.view[Behavior].any? { |b| b.ent == anim.ent }
      anim.container.view[BehaviorSignal] << BehaviorSignal.new(ent: anim.ent,
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
