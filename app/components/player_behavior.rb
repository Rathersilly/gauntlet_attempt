
module PlayerActions
  class Default < Behavior
    def default_anim args
      anim = @container.view[AnimGroup][@ent][0]
      @container.view[Anim][@ent] = anim
    end

    def on_tick args
      return unless enabled?
      @cooldown -= 1 if @cooldown > 0
    end
  end

  class Talk < Behavior
    def initialize
      @message_index = 0
      @messages = ["No! The DWARVES are cutting down the SACRED GROVE",
                   "Um, excuse me Mr. Dwarf, but this is the SACRED GROVE, you can't chop these trees!",
                   "But these trees contain the souls of my ancestors!",
                   "NO! I can't let you do this!",
                   "AHEM! YOU WILL CEASE THIS AT ONCE!",
                   "DROP YOUR AXES OR FACE ELVISH FURY!"]
    end

    def freeze
      @group.mobile = false
    end

    def unfreeze
      @group.mobile = true
    end

    def on_start args
      if check_talk_target args
        enable
        @message_index += 1 unless @message_index == 0
      end
    end

    def on_end args
    end

    def on_tick args
      return unless enabled?
      puts "TALKING ON TICK: weapon = #{@weapon}"
      msg = @messages[@message_index]
      @time ||= 0

      if @time < msg.length - 1
        @time += 1
      elsif @time == msg.length - 1
        @status = :wait_for_input
      end

      xform = @container[Xform][@ent]
      args.outputs.labels << [xform.x,xform.y + 120, @messages[@message_index][0..@time],6,1, *White,255]

    end

    def check_talk_target args
      xform = @container[Xform][@ent]
      dist = args.geometry.distance(xform, args.inputs.mouse)

      # find the dwarf you're talking to
      target_ent = 0 # initialize target ent - we dont want to talk to ourselves!
      args.state.mobs.view[Xform].each_with_index do |xform, ent|
        if args.geometry.inside_rect?({x:args.inputs.mouse.x, y:args.inputs.mouse.y,w:1,h:1}, xform.to_h)
          target_ent = ent
        end
      end

      if dist < 100 && target_ent > 2
        freeze
        @status = :talking
      end
    end

  end

end
class PlayerBehavior < BehaviorGroup
  attr_accessor :speed, :weapon, :cooldown

  def initialize **opts
    super
    @speed = opts[:speed]
    @weapon = :ice_missile
    @weapon = :nothing
    #@prev_status = :busy #to use when unfreezing a character
    @status = :default
    @cooldown = 120
    @mobile = true

    @behaviors << PlayerActions::Default.new
    @behaviors << PlayerActions::Talk.new
    @behaviors << PlayerActions::Move.new
    @behaviors << PlayerActions::IceMissile.new

  end

end
