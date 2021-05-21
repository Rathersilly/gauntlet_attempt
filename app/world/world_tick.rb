class World
  attr_gtk

  include InitWorld

  def tick
    #puts "\nWorld tick".magenta
    
    if args.state.tick_count >= 10 && @paused != false
      puts @paused
      pause_world
      acquire_politeness
      wait_for_key
      if @paused == false
        resume_world
      end
      puts @paused

    end

    Systems.each do |sys|
      next unless sys.status == :enabled
      Registries.each do |reg|
        if reg.views? sys.requirements
          # puts  "Invoking  #{sys.class} on #{reg.name}".green
          sys.tick args, reg
        else
          # puts  "NOT Invoking  #{sys.class} on #{reg.name}".red
        end
      end
    end
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
      # turn off animation and behavior
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
      args.outputs.labels << [1280/2,720/2+100,"WEAPON ACQUIRED:",6,1, *White]
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
end

