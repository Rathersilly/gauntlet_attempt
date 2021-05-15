require '/app/init/init.rb'

# These must be forward declared for reasons
module Init
end

module Tools
  # just tiny helper methods
end

# module AnimationSystem
#   # data is in the Anim class
# end

# module BehaviorSystem
# end

class Game
  attr_gtk

  include Init
  # include AnimationSystem
  # include BehaviorSystem
  Systems = []
  Systems << AnimationSystem
  Systems << BehaviorSystem

  def tick
    Systems.each do |system|
      system.tick args
    end
    # behavior
    # do_animation
    # cleanup
  end

  #
  def cleanup
    # need to call cleanup for each system
    # could create a systemcontainer field in Game
    # iterate through it
    # and call BehaviorSystem#cleanup etc
    # OR
    # could instantiate the systems as classes
    # would be elegant to have tick be just systems.each {|s| s.on_tick }
    # on_tick is in behaviors though, so maybe #invoke?

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
