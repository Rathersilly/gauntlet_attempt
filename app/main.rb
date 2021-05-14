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

class Game
  attr_gtk

  include Init
  include AnimationSystem

  def tick
    behavior
    do_animation
    cleanup
  end

  def behavior

    # this might get out of hand if many behaviors/signals
    # also these can be dried
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
    state.mobs.behavior_signals.reject! { |bs| bs.handled == true }
    state.spells.behavior_signals.reject! { |bs| bs.handled == true }
  end

end

def daily_report args
  puts "##### DAILY REPORT#####".cyan
  if args.state.spells.behavior_signals.any?
    puts "Behavior signals:\t\t\t: #{args.state.spells.behavior_signals}"
  end
  puts "Mob anims:\t\t\t: #{args.state.mobs.anims}"
  puts "Spell anims:\t\t\t: #{args.state.spells.anims}"
  #puts "#######################".cyan
  puts ""

end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
  if args.state.tick_count % 60 == 0
    daily_report args
  end

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
