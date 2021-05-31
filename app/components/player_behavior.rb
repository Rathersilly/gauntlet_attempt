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
    @sub_behaviors[:default] = PlayerSubBehaviors::Default.new(group: self, container: @container,ent: @ent)
    @sub_behaviors[:talk] = PlayerSubBehaviors::Talk.new(group: self, container: @container,ent: @ent)
    @sub_behaviors[:move] = PlayerSubBehaviors::Move.new(group: self, container: @container,ent: @ent)
    @sub_behaviors[:ice_missile] = PlayerSubBehaviors::IceMissile.new(group: self, container: @container,ent: @ent)
    @sub_behaviors[:fireball] = PlayerSubBehaviors::Fireball.new(group: self, container: @container,ent: @ent)
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

module PlayerSubBehaviors
  class Default < Behavior
    def default_anim args
      anim = @container.view[AnimGroup][@ent][0]
      @container.view[Anim][@ent] = anim
    end
  end

  class Talk < Behavior
    def initialize **opts
      super
      @message_index = 0
      @messages = [["No! The DWARVES are chopping down the SACRED GROVE",0],
                   ["Um, excuse me dwarves, you can't chop these trees!",0],
                   ["Ach Lassie, our coal seam is mined out!",1],
                   ["And we need to smelt metal for weapons",2],
                   ["To fight the NECROMANCER!",2],
                   ["These trees contain the souls of my ancestors!",0],
                   ["Away wi' ye, silly elf!",1],
                   ["AHEM! YOU WILL CEASE THIS AT ONCE!",0],
                   ["Ach, go dance with a fairy",1],
                   ["GRRR",0],
                   ["DROP YOUR AXES OR FACE ELVISH FURY!",0],
                   ["Elvish fury! Classic!",3],
                   ["She'll sick fairies on us, NOOO!",3],
                   ["Bwaaahahaha!",2],
                   ["Evil, stupid dwarves!",0]]
      @final_message = "DIE!"
      # @messages = Array.new(6) {|x| "Message #{x.to_s}"}
      # @responses = Array.new(6) {|x| "Response #{x.to_s}"}
      @enabled = false
      @string_index = 0

      @message_duration = 5
      @message_timer = 0

      @at_center = false
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
      enable
      @message_index = 0
      @status = :talking
      @group.cooldown = 20
    end

    def on_key_down args
    end

    def on_mouse_down args
      return unless enabled?
      puts "TALK MOUSE DOWN - status: #{@status}, msg index: #{@message_index}".blue
      p @message_timer
      p @message_duration

      if @message_index == @messages.size
        @status = :final_message
        @dest = [640,360]
        @dirx, @diry = Tools.set_dir(xform, @dest)
        @final_cooldown = 30
      elsif @status == :default && @group.cooldown == 0
        @group.cooldown = 10
        @status = :talking
      end

    end

    def final_message args
      if @at_center
        @final_cooldown -= 1
        if @final_cooldown == 0
          args.state.mobs[Team].each.with_index do |team, ent|
            if team.name == :enemy
              args.state.mobs[Behavior][0].sub_behaviors[:fireball].shoot_fireball_at(args, ent)
            end
          end

          @status = :default
          disable
          # do some other event thing
          return
        end
        args.outputs.labels << {x: xform.x, y: xform.y + 130,
                                text: @final_message,
                                size_enum: 20,
                                alignment_enum: 1,
                                r:255,g:0,b:0}
      else
        move_to_center(args)
      end
    end

    def on_tick args
      return unless enabled?
      final_message args if @status == :final_message
      return unless @status == :talking
      puts "TALK On tick- status: #{@status}, msg index: #{@message_index}".brown
      puts "message timer: #{@message_timer}"
      @message_timer += 1
      if @message_timer == @message_duration
        @message_index += 1
        @message_timer = 0
        @status = :default
        return
      end

      @talking_xform = args.state.mobs[Xform][@messages[@message_index][1]]
      p @talking_xform

      args.outputs.labels << {x: @talking_xform.x, y: @talking_xform.y + 130,
                              text: @messages[@message_index][0],
                              size_enum: 6,
                              alignment_enum: 1,
                              r:255,g:255,b:255}
    end

    def select_responder args
      puts "selecting responder".magenta
      p args.state.mobs
      p args.state.mobs
      @responder_xform = args.state.mobs[Xform][1..4].sample
      p @responder_xform
    end

    def move_to_center args
      if args.geometry.distance([self.xform.x,self.xform.y],@dest) > 20
        puts "moving to dest".red
        @message_index = 5
        speed = 10
        self.xform.x += @dirx * speed
        self.xform.y += @diry * speed
      else
        @dest = nil
        @at_center = true
      end
    end

  end
end
