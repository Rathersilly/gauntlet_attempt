class PlayerBehavior < Behavior
  attr_accessor :speed, :weapon

  def initialize **opts
    super
    @speed = opts[:speed]
    @weapon = :ice_missile
    @weapon = :nothing
    #@prev_status = :busy #to use when unfreezing a character
    @status = :default
    @cooldown = 2
    @mobile = true
    @message_index = 0
    @messages = ["No! The DWARVES are cutting down the SACRED GROVE",
                 "Um, excuse me Mr. Dwarf, but this is the SACRED GROVE, you can't chop these trees!",
                 "But these trees contain the souls of my ancestors!",
                 "NO! I can't let you do this!",
                 "AHEM! YOU WILL CEASE THIS AT ONCE!",
                 "DROP YOUR AXES OR FACE ELVISH FURY!"]

  end

  def handle bs, args
    super
    if bs.message == :first_speech
      first_speech args
    end
  end

  def freeze
    @mobile = false
    @prev_status = @status
    # @status = #wait for something
  end

  def unfreeze
    @mobile = true
    @status = @prev_status
  end

  def default_anim args
    anim = @container.view[AnimGroup][@ent][0]
    @container.view[Anim][@ent] = anim
  end

  def on_mouse_down args
    return if @status == :talking
    if @status == :wait_for_input
      @message_index += 1 unless @message_index = @messages.size - 1
      unfreeze
      @time = 0
      return 
    end
    return if @cooldown > 0
    attack args
  end

  def on_key_down args
    move args
  end

  def attack args
    # puts "ATTACKING"

    # puts @ent
    # Tools.megainspect self
    # puts "ANIMS"
    # p args.state.anims

    if @weapon == :ice_missile
      shoot_ice_missile args
    elsif @weapon == :politeness
      talk args

    end
  end

  def on_tick args
    if @status == :talking || @status == :wait_for_input
      talk args
    elsif args.state.tick_count % 60 == 0
      if @cooldown > 0
        @status = :default
        @cooldown -= 1 
      end
    end
  end

  def first_speech args
    freeze
    @status = :talking
    talk args
  end

  def talk args
    puts "TALKING: weapon = #{@weapon}"
    if @status != :talking
      check_talk_target args
    end
    return unless @status == :talking || :wait_for_input

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
      talk args
    end
  end

end
