module PlayerSubBehaviors
  class Default < Behavior
    def default_anim args
      anim = @container.view[AnimGroup][@ent][0]
      @container.view[Anim][@ent] = anim
    end

    def on_tick args
      return unless enabled?
      @group.cooldown -= 1 if @group.cooldown > 0
    end
  end

  class Talk < Behavior
    def initialize **opts
      super
      @message_index = 0
      @messages = ["No! The DWARVES are cutting down the SACRED GROVE",
                   "Um, excuse me Mr. Dwarf, but this is the SACRED GROVE, you can't chop these trees!",
                   "But these trees contain the souls of my ancestors!",
                   "NO! I can't let you do this!",
                   "AHEM! YOU WILL CEASE THIS AT ONCE!",
                   "DROP YOUR AXES OR FACE ELVISH FURY!"]
      @enabled = false
    end

    def freeze
      @group.mobile = false
    end

    def unfreeze
      @group.mobile = true
    end

    def first_talk args
      # what is said when crossing the first trigger
      puts "FIRST TALK".blue
      freeze
      enable
      @message_index = 0
    end

    def start args
      if check_talk_target(args)
        freeze
        enable
        @message_index += 1 unless @message_index == 0
      end
    end

    def finish args
    end
    def on_key_down args
      # on_mouse_down args
    end
    def on_mouse_down args
      if @status == :wait_for_input
        unfreeze
        disable
        @group.weapon = :ice_missile
        @group.cooldown = 60
        @status = :default
        return
      end
      puts "TALK MOUSE DOWN".blue
      return unless @group.weapon == :politeness
      enable
    end

    def on_tick args

      return unless enabled?
      # puts "TALKING ON TICK: weapon = #{@group.weapon}"
      msg = @messages[@message_index]
      @time ||= 0

      if @time < msg.length - 1
        @time += 1
      elsif @time == msg.length - 1 && @status != :wait_for_input
        @status = :wait_for_input
        @group.cooldown = 60

      end

      xform = @container[Xform][@ent]
      args.outputs.labels << [xform.x,xform.y + 120, @messages[@message_index][0..@time],6,1, *White,255]
      if @status == :wait_for_input && @group.cooldown == 0
        args.outputs.labels << [xform.x,xform.y + 100, "(press any key)",6,1, *White,255]
      end


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
class PlayerBehavior < Behavior
  attr_accessor :speed, :weapon, :cooldown, :mobile

  def initialize **opts
    super
    @speed = opts[:speed]
    @weapon = :ice_missile
    @weapon = :politeness
    #@prev_status = :busy #to use when unfreezing a character
    @status = :default
    @cooldown = 0
    @mobile = true

    @sub_behaviors = {}
    @sub_behaviors[:default] = PlayerSubBehaviors::Default.new(group: self)
    @sub_behaviors[:talk] = PlayerSubBehaviors::Talk.new(group: self)
    @sub_behaviors[:move] = PlayerSubBehaviors::Move.new(group: self)
    @sub_behaviors[:ice_missile] = PlayerSubBehaviors::IceMissile.new(group: self)
  end
  def default_anim args
    @sub_behaviors.each do |b|
      puts b.class
      p b.class

    end
    @sub_behaviors[:default].default_anim(args)
  end
  def on_tick args
    @cooldown -= 1 if @cooldown > 0
    @sub_behaviors.each_value do |b|
      b.on_tick args
    end
  end
  def on_key_down args
    @sub_behaviors.each_value do |b|
      b.on_key_down args
    end
  end
  def on_mouse_down args
    @sub_behaviors.each_value do |b|
      b.on_mouse_down args
    end
  end
  def handle bs, args
    if bs.message == :first_talk
      puts "HANDLING FIRST SPEECH".blue
      @sub_behaviors[:talk].first_talk args
    end
    super
  end

end
