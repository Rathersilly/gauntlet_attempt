module Level1
  class LevelBehavior < Behavior
    def initialize args
      @world_paused = false
      @duration = 10

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
    end
  end

  class GameStart < LevelBehavior
    def initialize args
      super
      @enabled = true
      # !!! disabled
      # @enabled = false
      # @duration = 80
      @duration = 10
      @text_alpha = 0
    end

    def on_tick args
      super
      if @text_alpha < 255 
        @text_alpha +=5 
      end
      args.outputs.primitives << [640,400,"Elf RAGE", 30,1,*White,@text_alpha].label
    end
  end

  class TriggerPolite < LevelBehavior
    def initialize args
      super
      @enabled = false
    end

    def on_tick args
      super
      puts "TriggerPolite on tick".magenta

      args.outputs.primitives << [640,400,"Weapon switch:", 20,1,*White].label
      args.outputs.primitives << [640,300,"Politeness", 30,1,*White].label
    end
  end

  class TriggerStern < LevelBehavior
    def initialize args
      super
      @enabled = false
    end

    def on_tick args
      super
      puts "TriggerStern on tick".magenta

      args.outputs.primitives << [640,400,"Weapon switch:", 20,1,*White].label
      args.outputs.primitives << [640,300,"Sternness", 30,1,*White].label
    end
  end

  class TriggerMissile < LevelBehavior
    def initialize args
      super
      @enabled = false
      ## !!! testing
      # @enabled = true
      
    end
    
    def on_tick args
      if @duration == 1
        # shoot fireball at every dwarf
      end

      super
      puts "TriggerMissile on tick".magenta

      args.outputs.primitives << [640,400,"Weapon switch:", 20,1,*White].label
      args.outputs.primitives << [640,300,"Ultimate Deathspell of Fiery Doom", 30,1,*White].label


    end
  end
end
