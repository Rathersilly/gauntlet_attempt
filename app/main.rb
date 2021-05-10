require '/app/init/init.rb'

module Init
  # These must be forward declared for reasons
end

module Tools
end

module AnimationSystem
  # data is in the Anim class
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
    #behavior
    render
    #cleanup
  end

  def behavior

    if !state.behavior_signals.empty?
      state.behavior_signals.each do |bs|
        state.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      state.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    # puts "key_down"
    # p inputs.keyboard.key_down
    # puts "key_down_or_held"
    # p inputs.keyboard.key_down_or_held
    state.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      # this was in a separate each loop - probably fine to keep it here?
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end

  def cleanup
    # a lot of this is unnecessary after limiting 1 xform/anim per entity
    
    # puts "CLEANUP"
    # p state.anims
    # p state.spell_anims

    #state.spell_anims.reject! do |anim|

    #  next unless anim
    #  #puts "SPELL CLEANUP"
    #  truthflag = false
    #  if anim.state == :done 
    #    truthflag =  true
    #  end
    #  truthflag
    #end

    state.anims.reject! { |anim| anim.state == :done }
    state.behavior_signals.reject! { |bs| bs.handled == true }
  end

end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
