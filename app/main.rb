
# These must be forward declared for reasons
module Init
end

module Tools
  # just tiny helper methods
end
class System
end
class Animation < System
  # data is in the Anim class
end
class Render < System
end

class Behaviorsys < System
end
class ComponentRegistry
end
require '/app/init/init.rb'

class Game
  attr_gtk

  include Init

  Systems = []
  Systems << Animation.new
  Systems << Behaviorsys.new
  Systems << Render.new

  def tick
    Registries.each do |reg|
      Systems.each do |sys|
        sys.tick args, reg
      end
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
