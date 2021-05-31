class SpellBehavior < Behavior
  attr_accessor :dirx, :diry, :speed

  def initialize **opts
    super
    @speed = opts[:speed] || 0
    @dir = opts[:dir] || 0
    @damage = opts[:damage] || 1
    @mobile = true
  end

  def on_tick args
    return if @mobile == false
    xform = @container.view[Xform][@ent]
    if !@dirx
      @dirx, @diry = Tools.set_dir(xform, @dest)
    end
    xform.x += @dirx * speed
    xform.y += @diry * speed
  end

  def on_collision args, **info
    puts "SPELL on_collision".blue
    p self
    p self.ent
    p @container
    puts "OTHER TEAM"
    #puts info[:reg][Team][info[:ent]]
    if @container.view[Team][@ent] != info[:reg].view[Team][info[:ent]]
      @container.delete(@ent)
    end
    #if info[:reg][Team][info[:ent]] == enemy team
    #if info[:team] == #enemy team
        # mark this spell as being done
        #end

  end
end

class FireballBehavior < SpellBehavior
  def handle bs, args
    if @container.view[Anim][@ent] == @container[AnimGroup][@ent][1]
      @container.delete(@ent)
    end
  end

  def on_collision args, **info
    puts "Fireball on_collision".blue
    @mobile = false
    p self
    p self.ent
    p @container
    puts "OTHER TEAM"
    #puts info[:reg][Team][info[:ent]]
    if @container.view[Team][@ent] != info[:reg].view[Team][info[:ent]]
      puts "changing fireball anim".blue
      @container.view[Anim][@ent] = @container[AnimGroup][@ent][1]
      p @container[AnimGroup][@ent][1]
      p @container[AnimGroup][@ent][1].frames


    end
    #if info[:reg][Team][info[:ent]] == enemy team
    #if info[:team] == #enemy team
    # mark this spell as being done
    #end

  end
end
