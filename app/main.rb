require '/app/init/init.rb'

# These must be forward declared for reasons
module Init
end

module Tools
  # just tiny helper methods
end

module AnimationSystem
  # data is in the Anim class
end

class ComponentStore
  #each componentcontainer has its own set of ids
  #SpellContainer = ComponentContainer.new
  # so going to have args.state.spells SpellContainer 
  # and state.mobs = MobContainer
  #
  # each of these is an array, where index = entity_id.
  # the mechanism for adding multiple behaviors is to use modules
  # although, gonna need containers for anims anyway

  # this class might also keep track of the active component of each
  # collection - or delegate that to behavior?
  attr_accessor :id, :xforms, :anims, :behaviors
  attr_accessor :active_xforms, :active_anims, :active_behaviors
  attr_accessor :anim_stores

  def initialize
    @xforms = []
    @anims = []
    @anim_stores = []
    @behaviors = []
    @id = -1
  end

  def << **components
    id = new_entity_id
    @xforms[id] = components[:xform]
    @behaviors[id] = components[:behavior]

    @anim_stores[id] = components[:anim_store]
    if @anim_stores[id].empty?
      @anims[id] = nil
    else
      @anims[id] = @anim_stores[id][0]
    end
    
    init_components id, components
  end

  def init_components id, **components
    puts "INITTING COMPONENTS"
    p components
    components.each_value do |component|
      if component.class.ancestors.include?(Component)
        component.ent = id
        component.container = self
        puts "INIT COMPONENT"
        p component.ent
        p component.container
        puts "@#@#@#@#@#@#"
      end
    end
  end

  def components
  end

  def new_entity_id
    @id += 1
  end

  def inspect
    puts "inspecting Store"
    p @xforms
    p @anim_stores
    p @anims
    p @behaviors
  end

end

class Game
  attr_gtk

  include Init
  include AnimationSystem

  def new_entity_id
    args.state.entity_id += 1
  end

  def new_spell_id
    args.state.spell_id += 1
  end

  def tick
    behavior
    do_animation
    #cleanup
  end

  def behavior

    # this might get out of hand if many behaviors/signals
    # if state.behavior_signals.any?
    #   state.behavior_signals.each do |bs|
    #     state.behaviors.each do |b|
    #       if b.ent == bs.ent
    #         b.handle(bs, args)
    #       end
    #     end
    #   end
    # end

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      state.mobs.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    state.mobs.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      # b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end
    state.spells.behaviors.each do |b|
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end

  def cleanup
    # a lot of this is unnecessary after limiting 1 xform/anim per entity

    # puts "CLEANUP"
    # p state.anims
    # state.anims.reject! do |anim|

    #   anim.state == :done 
    # end

    # state.spells.anims.reject! do |anim|

    #   next unless anim
    #   truthflag = false
    #   if anim.state == :done 
    #     puts "SPELL CLEANUP"
    #     Tools.megainspect anim
    #     truthflag = true
    #   end
    #   truthflag
    # end

    #state.anims.reject! { |anim| anim.state == :done }
    #state.spells.anims.reject! { |anim| anim.state == :done }

    state.behavior_signals.reject! { |bs| bs.handled == true }
    state.spells.behavior_signals.reject! { |bs| bs.handled == true }

  end

end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
  if args.state.tick_count % 60 == 0
  end
    
  #puts args.state.xforms[1]
  #puts args.state.anims[1]

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
