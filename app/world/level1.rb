module Level1
  class GameStart < Behavior

    # disable all but animation and render
    # fade in

    def initialize args
      @enabled = true
      @world_paused = false
      @duration = 60


    end

    def on_tick args
      @duration -= 1
      if @duration == 0
        resume_world args
        lighten_world args
        disable
        return
      end
      if @world_paused == false
        @world_paused = true
        pause_world args
      end

      darken_world args
      args.outputs.primitives << [600,600,"HIHIHI"].label
    end

  end

  class Trigger1 < Behavior
    def initialize args
      @enabled = false
      # pause_world args


    end
  end
  class Trigger2 < Behavior
    def initialize args
      @enabled = false
      # pause_world args
    end


  end
end


