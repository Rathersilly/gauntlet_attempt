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
      @messages = Array.new(5) {|x| "Message #{x.to_s}"}
      @enabled = false
      @string_index = 0
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

    def finish args
    end

    def on_key_down args
      # on_mouse_down args
    end

    def on_mouse_down args
      return unless @group.cooldown == 0
      puts "TALK MOUSE DOWN - status: #{@status}, msg index: #{@message_index}".blue
      if @status == :wait_for_input
          @message_index += 1
          @string_index = 0
          unfreeze
          disable
        if @group.weapon == :nothing
          @group.weapon = :politeness
          args.state.events[:trigger_polite].enable
        elsif @group.weapon == :politeness && @message_index == 3
          @group.weapon = :sternness
          args.state.events[:trigger_stern].enable
        elsif @group.weapon == :sternness && @message_index == 5
          @group.weapon = :ice_missile
          args.state.events[:trigger_missile].enable
        end
        @group.cooldown = 60
        @status = :default
      elsif @group.weapon == :politeness && @group.cooldown == 0
        if check_talk_target(args)
          puts "Checking target"
          freeze
          enable
        end

      elsif @group.weapon == :sternness && @group.cooldown == 0

        if check_talk_target(args)
          puts "Checking target"
          freeze
          enable
        end

      end
    end

    def on_tick args
      return unless enabled?

      # puts "TALKING ON TICK: weapon = #{@group.weapon}"
      msg = @messages[@message_index]

      if @string_index < msg.length - 1
        @string_index += 1
      elsif @string_index == msg.length - 1 && @status != :wait_for_input
        @status = :wait_for_input

      end

      xform = @container[Xform][@ent]
      args.outputs.labels << [xform.x,xform.y + 130, @messages[@message_index][0..@string_index],6,1, *White,255]
      if @status == :wait_for_input && @group.cooldown == 0
        args.outputs.labels << [xform.x,xform.y + 110, "(press any key)",6,1, *White,255]
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
  attr_accessor :speed, :weapon, :mobile

  def initialize **opts
    super
    @speed = opts[:speed]
    @weapon = :ice_missile
    @weapon = :politeness
    @weapon = :nothing
    #@prev_status = :busy #to use when unfreezing a character
    @status = :default
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
