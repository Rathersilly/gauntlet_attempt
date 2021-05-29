class World
  attr_gtk

  include InitWorld

  def daily_report
    args.outputs.labels << [700,700,"Player Info"]
    args.outputs.labels << [700,680,"Status: #{args.state.mobs[Behavior][0].status}"]
    args.outputs.labels << [700,660,"Weapon: #{args.state.mobs[Behavior][0].weapon}"]
    args.outputs.labels << [700,640,"Cooldown: #{args.state.mobs[Behavior][0].cooldown}"]
  end

  def tick
    # puts "\nWorld tick".magenta
    
    # only_animation
    # only_render

    args.state.events.each do |event|
      next unless event.enabled?
      event.on_tick args
    end

    args.state.systems.each_value do |sys|
      # puts  "System  #{sys.class}: enabled=#{sys.enabled}".blue
      next unless sys.enabled?
      args.state.registries.each do |reg|
        if reg.views? sys.requirements
          # puts  "Invoking  #{sys.class} on #{reg.name}".green
          sys.tick args, reg
        else
          # puts  "NOT Invoking  #{sys.class} on #{reg.name}".red
        end
      end
    end

    if args.state.darken
    args.outputs.primitives << {x:0,y:0,w:1280,h:720,
                                r: 0,b:0,g:0,a:100}.solid
    end

    daily_report
  end

  def only_animation_render
    args.state.systems.each do |sys|
      sys.disable
      case sys
      when RenderSprites
        sys.enable
      when AnimSystem
        sys.enable
      end
    end
  end
  def only_render
    args.state.systems.each do |sys|
      sys.disable
      case sys
      when RenderSprites
        sys.enable
      when AnimSystem
      end
    end
  end

  def only_animation
    args.state.systems.each do |sys|
      sys.disable
      case sys
      when RenderSprites
      when AnimSystem
        sys.enable
      end
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
    args.state.systems.each do |sys|
      puts "#{sys.class}:\t\t#{sys.enabled?}"
    end
  end
end

