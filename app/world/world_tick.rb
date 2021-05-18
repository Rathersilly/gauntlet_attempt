class World
  attr_gtk

  include InitWorld

  def tick
    #puts "\nWorld tick".magenta

    Systems.each do |sys|
      Registries.each do |reg|
        if reg.views? sys.requirements
          puts  "Invoking  #{sys.class} on #{reg.name}".green
          sys.tick args, reg
        else
          puts  "NOT Invoking  #{sys.class} on #{reg.name}".red
        end
      end
    end
  end

end

