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
require '/app/components/behavior.rb'
require '/app/component_registry.rb'

require '/app/systems/system.rb'
require '/app/systems/animation.rb'
require '/app/systems/render.rb'
require '/app/systems/behavior.rb'
require '/app/systems/behavior_mods.rb'

require '/app/init/init_anims.rb'

require '/app/factories/factory_template.rb'
# require '/app/factories/mage_factory.rb'
# require '/app/factories/archmage_factory.rb'
require '/app/factories/steelclad_factory.rb'
# require '/app/factories/adept_factory.rb'
# require '/app/factories/spell_factory.rb'

module Init
  # this will be included in world class

  def initialize args

    # Spells = ComponentRegistry.new
    # Spells.max_ids = 3
    Mobs = ComponentRegistry.new

    Registries = []
    Registries << Mobs
    # Registries << Spells

    # would like to see check if Registries updates with args
    # if it is reference
    # args.state.spells     = Spells
    args.state.mobs       = Mobs
    args.state.all_anims  = {}

    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs

    init_anims 

    #Mobs << MageFactory.create(args)
    p Mobs
    args.state.hero = 0
    # AdeptFactory.create args, {x: 900,y:400}
    3.times do |i|
      Mobs << SteelCladFactory.create(args, {x: rand(1280),y:rand(720)})
    end
    p Mobs
  end
end

