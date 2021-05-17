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

require '/app/init/tools.rb'

require '/app/components/components.rb'
require '/app/components/anim.rb'
require '/app/components/anim_store.rb'
require '/app/components/behavior.rb'
require '/app/component_registry.rb'

require '/app/systems/system.rb'
require '/app/systems/animation.rb'
require '/app/systems/render_static_solids.rb'
require '/app/systems/render_solids.rb'
require '/app/systems/render_sprites.rb'
require '/app/systems/behavior.rb'
require '/app/systems/behavior_mods.rb'
require '/app/systems/cleanup.rb'

require '/app/init/init_anims.rb'

require '/app/factories/factory.rb'
require '/app/factories/block_factory.rb'
require '/app/factories/mage_factory.rb'
# require '/app/factories/archmage_factory.rb'
require '/app/factories/steelclad_factory.rb'
require '/app/factories/adept_factory.rb'
require '/app/factories/spell_factory.rb'

module Init
  # this will be included in World class

  def initialize args
    Systems = []
    Systems << Animation.new
    Systems << Behaviorsys.new
    #Systems << RenderSolids.new
    # Systems << RenderStaticSolids.new
    Systems << RenderSprites.new
    Systems << Cleanup.new

    Spells = ComponentRegistry.new do |cr|
      cr.name = "Spells"
      cr.create_view Xform, Anim, Behavior
      cr.max_ids = 3
    end

    Mobs = ComponentRegistry.new do |cr|
      cr.name = "Mobs"
      cr.create_view Xform, Anim, Behavior
    end

    Map = ComponentRegistry.new do |cr|
      cr.name = "Map"
      cr.create_view Xform, Color
    end

    Registries = []

    Registries << Map
    Registries << Mobs
    Registries << Spells

    args.state.mobs       = Mobs
    args.state.spells     = Spells
    args.state.all_anims  = {}

    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs

    init_anims 

    Mobs << MageFactory.create(args)
    args.state.hero = 0
    Mobs << AdeptFactory.create(args, {x: 900,y:400})
    50.times do |i|
      Mobs << SteelCladFactory.create(args, {x: rand(1280),y:rand(720)})
    end

    create_map
    render_map
  end
  def create_map
    puts "Create map".cyan
    p Spells
    tile_size = 80
    16.times do |x|
      9.times do |y|
        tile = BlockFactory.create(args, x:x* tile_size,y:y* tile_size,w:tile_size,h:tile_size,
                                  r: rand(255),g:rand(255),b:rand(255))
        p tile
        Map << tile 
      end
    end

    puts "MAP"
    p Map
    p Spells
  end
  def render_map
    RenderStaticSolids.new.tick args, Map
  end
end

