class World
  attr_gtk

  include InitWorld

  def daily_report
    args.outputs.labels << [700,700,"Player Info"]
    args.outputs.labels << [700,680,"Status: #{args.state.mobs[BehaviorGroup][0].status}"]
    args.outputs.labels << [700,660,"Weapon: #{args.state.mobs[BehaviorGroup][0].weapon}"]
    args.outputs.labels << [700,640,"Cooldown: #{args.state.mobs[BehaviorGroup][0].cooldown}"]
  end
  def tick
    #puts "\nWorld tick".magenta
    
    # only_animation
    
    if args.state.tick_count == 10
      # pause_world
    end
    if @paused == true
      acquire_politeness
      pause_world
      wait_for_key
      msg
    end

    Systems.each do |sys|
      # puts  "System  #{sys.class}: enabled=#{sys.enabled}".blue
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

    # daily_report
  end

  def only_animation
    Systems.each do |sys|
      sys.disable
      case sys
      when RenderSprites
        sys.enable
      when AnimSystem
        sys.enable
      end
    end
  end

  def pause_world
    puts "PAUSING"
    @paused = true
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
    args.state.mobs[BehaviorGroup][0].weapon = :politeness
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
      resume_world
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

