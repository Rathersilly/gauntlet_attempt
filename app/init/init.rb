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

#All_anims = {}  #dont need anim_pail in state
# Known anims can be looked up by entity_id
Known_anims = []

require '/app/init/tools.rb'

require '/app/components.rb'

require '/app/systems/animation.rb'
require '/app/systems/behavior.rb'

require '/app/init/init_anims.rb'

require '/app/factories/factory_template.rb'
require '/app/factories/mage_factory.rb'
require '/app/factories/archmage_factory.rb'
require '/app/factories/steelclad_factory.rb'
require '/app/factories/adept_factory.rb'
require '/app/factories/spell_factory.rb'

module Init

  def initialize args
    # initialize each component container

    args.state.map = Array.new(20) { Array.new(20) }


    args.state.xforms                 = []
    args.state.anims                  = []
    args.state.sprites                = []

    # spells NYI in this branch
    args.state.spell_anims            = []
    args.state.spell_behaviors        = []

    args.state.behaviors              = []
    args.state.behavior_signals       = []
    args.state.anim_pail              = {}

    args.state.entity_id              = -1
    args.state.spell_id               = -1


    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs

    init_anims 

    MageFactory.create args
    args.state.hero = 0
    20.times do |i|
      # SteelCladFactory.create args, {x: 700,y:100 *  i}
      SteelCladFactory.create args, {x: rand(1280),y:rand(720)}
    end
    AdeptFactory.create args, {x: 900,y:400}
  end
end

