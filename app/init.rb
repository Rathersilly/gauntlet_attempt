# palette:
def colorhex(str)
  color = []
  color << str[0..1].hex
  color << str[2..3].hex
  color << str[4..5].hex
end
Darkblue = colorhex('264653')
Green = colorhex('2a9d8f')
Yellow = colorhex('e9c46a')
Orange = colorhex('f4a261')
Red = colorhex('e76f51')
Black = colorhex('000000')
White = colorhex('ffffff')
Colors = [Darkblue,Green,Yellow,Orange,Red]

Known_anims = []


module Init


  require '/app/components.rb'
  require '/app/ents.rb'

  require '/app/factory_template.rb'
  require '/app/init_anims.rb'

  require '/app/mage_factory.rb'
  require '/app/archmage_factory.rb'
  require '/app/steelclad_factory.rb'
  require '/app/adept_factory.rb'
  require '/app/spell_factory.rb'
  #require '/app/init_siegeguy.rb'

end



# module to handle mobs with 4 directional anims (including horiz flip)
# module to be included in a Behavior class
module Mob4d
  def move_to_hero args
    hero = args.state.hero
    hero_xform = args.state.xforms[hero]
    set_dir(args, [hero_xform.x,hero_xform.y])
  end
  def on_tick args

    if args.state.tick_count % 30 == 0
      move_to_hero args
    end
    xform = args.state.xforms[@ent]
    anim = args.state.anims[@ent]
    
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
    #print "#{anim.cur_time} / #{anim.frame_dur}\n"
  end


end
    

