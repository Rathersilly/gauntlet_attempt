# module to handle mobs with 4 directional anims (including horiz flip)
# module to be included in a Behavior class
module Mob4d
  def move_to_hero args
    hero = args.state.hero
    hero_xform = args.state.mobs.view[Xform][hero]
    @dirx, @diry = Tools.set_dir(@container.view[Xform][@ent], [hero_xform.x,hero_xform.y])
  end

  def on_tick args
    return unless @mobile

    if args.state.tick_count % 30 == 0
      move_to_hero args
    end
    xform = @container.view[Xform][@ent]
    anim = @container.view[Anim][@ent]
    
    xform.x += @dirx * speed
    xform.y += @diry * speed
    if @dirx <= 0
      anim.flip_horizontally = true
    else
      anim.flip_horizontally = false
    end
    if @diry <= 0
      anim.up = false
    else
      anim.up = true
    end
    #puts anim.frame_index
    #print "#{anim.cur_time} / #{anim.frame_duration}\n"
  end

end
    


