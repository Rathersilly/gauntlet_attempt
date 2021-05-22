class World
  attr_gtk

  include InitWorld

  def daily_report
    args.outputs.labels << [700,700,"Player Info"]
    args.outputs.labels << [700,680,"Status: #{args.state.mobs[Behavior][0].status}"]
    args.outputs.labels << [700,660,"Weapon: #{args.state.mobs[Behavior][0].weapon}"]
    args.outputs.labels << [700,640,"Player Info"]
  end
  def tick
    #puts "\nWorld tick".magenta
    
    @paused ||= :hi
    if args.state.tick_count >= 10 || @paused == true
      # puts @paused
      pause_world
      acquire_politeness
      wait_for_key
      if @paused == false
        resume_world
      end
      msg

    end

    Systems.each do |sys|
      next unless sys.enabled?
      Registries.each do |reg|
        if reg.views? sys.requirements
          # puts  "Invoking  #{sys.class} on #{reg.name}".green
          sys.tick args, reg
        else
          # puts  "NOT Invoking  #{sys.class} on #{reg.name}".red
        end
      end
    end
    # Events.each do |event|
    #   event.tick args
    # end

    daily_report
  end

  def pause_world
    @paused ||= true
    Systems.each do |sys|
      case sys
      when BehaviorSystem
        sys.disable
      when AnimSystem
        sys.disable
      end
    end
    args.outputs.primitives << {x:0,y:0,w:1280,h:720,
                                r:0,b:0,g:0,a:200}.solid

  end

  def resume_world
    Systems.each do |sys|
      sys.enable
    end
  end

  def acquire_politeness
    @msg_start ||= args.state.tick_count
    args.state.mobs[Behavior][0].weapon = :politeness
    args.outputs.labels << [1280/2,720/2+100,"WEAPON SWITCHED TO:",6,1, *White]
    args.outputs.labels << [1280/2,720/2,"POLITENESS",12,1, *White]
    if args.state.tick_count - @msg_start > 60
      args.outputs.labels << [1280/2,720/2-100,"(press any key)",6,1, *White]
    end
  end

  def acquire_sternness
  end

  def wait_for_key
    if args.inputs.mouse.down
      @paused = false
    end
  end

  def msg
    @time ||= args.state.tick_count
    @time += 1

    msg = "No! The DWARVES are cutting down the SACRED GROVE"
    return if @time >= msg.length
    args.outputs.labels << [1280/2,720/2-200, msg[0..@time],6,1, *White]
  end

  def system_check
    Systems.each do |sys|
      puts "#{sys.class}:\t\t#{sys.enabled?}"
    end
  end
end

