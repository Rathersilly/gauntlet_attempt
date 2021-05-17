# These must be forward declared for reasons
module Init;  end
module Tools; end

class System;               end
class Animation < System;   end
class RenderSprite < System;      end
class RenderSolids < System;      end
class Cleanup < System;     end
class Behaviorsys < System; end
class ComponentRegistry;    end

require '/app/init/init.rb'

class Game
  attr_gtk

  include Init


  def tick
    #puts "\nWorld tick".magenta

    Systems.each do |sys|
      Registries.each do |reg|
        if reg.views? sys.requirements
          # puts  "Invoking  #{sys.class} on #{reg.name}".green
          sys.tick args, reg
        else
          # puts  "NOT Invoking  #{sys.class} on #{reg.name}".red
        end
      end
    end
  end

end

def daily_report args
  puts "##### DAILY REPORT#####".cyan
  if args.state.spells.behavior_signals.any?
    puts "Behavior signals:\t\t: #{args.state.spells.behavior_signals}"
  end
  puts "Mob anims:\t\t\t: #{args.state.mobs.anims}"
  puts "Spell anims:\t\t\t: #{args.state.spells.anims}"
  #puts "#######################".cyan
  puts ""

end
def report2 args
  args.outputs.labels << [800,700,"Mobs: #{args.state.mobs}"]
  args.outputs.labels << [800,680,"Spells: #{args.state.spells}"]
  args.outputs.labels << [800,660,"BS: #{args.state.mobs.behavior_signals}"]
  args.outputs.labels << [800,640,"BS: #{args.state.mobs.behavior_signals.class}"]
end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
  if args.state.tick_count % 60 == 0
    #daily_report args
  end
  #report2 args

  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end
