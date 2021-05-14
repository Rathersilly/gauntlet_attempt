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
  attr_accessor :id, :max_ids, :xforms, :anims, :behaviors, :behavior_signals
  attr_accessor :active_xforms, :active_anims, :active_behaviors
  attr_accessor :anim_stores

  def initialize
    @xforms = []
    @anims = []
    @anim_stores = []
    @behaviors = []
    @behavior_signals = []
    @id = -1
    @max_ids = nil
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
      p component
      p component.class.ancestors
      if component.class.ancestors.include?(Component)
        component.ent = id
        component.container = self
      end
      if component.class == Array
        component.each do |subcomponent|
          subcomponent.ent = id
          subcomponent.container = self
        end
      end
    end
    puts "ANIMS ID"
    p @anims[id].ent
    p @anims[id].container
  end

  def components
  end

  def new_entity_id
    @id += 1
    if @max_ids && @id == @max_ids
      # need function to clear out this id
      @id = 0
    end
    @id
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
    cleanup
  end

  def behavior

    #this might get out of hand if many behaviors/signals
    if state.spells.behavior_signals.any?
      state.spells.behavior_signals.each do |bs|
        state.spells.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    if state.mobs.behavior_signals.any?
      state.mobs.behavior_signals.each do |bs|
        state.mobs.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      state.mobs.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    state.mobs.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end
    state.spells.behaviors.each do |b|
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end

  def cleanup
    # spell cleanup
    
    # actually, they will get cleaned up on their own if you make a limit on
    # the  # of spells and overwrite their entity_ids
    #state.spells.anims.reject! { |anim| anim.state == :done }

    state.mobs.behavior_signals.reject! { |bs| bs.handled == true }
    state.spells.behavior_signals.reject! { |bs| bs.handled == true }
  end

end

def daily_report args
  puts "##### DAILY REPORT#####"
  if args.state.spells.behavior_signals.any?
    puts "Behavior signals:\t\t\t: #{args.state.spells.behavior_signals}"
  end
    puts "Mob anims:\t\t\t: #{args.state.mobs.anims}"
    puts "Spell anims:\t\t\t: #{args.state.spells.anims}"

end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
  if args.state.tick_count % 60 == 0
    daily_report args

    p args.state.spells.behavior_signals
  end

  #puts args.state.xforms[1]
  #puts args.state.anims[1]

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
