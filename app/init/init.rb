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
  require '/app/init/tools.rb'

  require '/app/components.rb'
  require '/app/ents.rb'
  require '/app/systems/animation.rb'
  require '/app/systems/behavior.rb'

  require '/app/factories/factory_template.rb'
  require '/app/init/init_anims.rb'

  require '/app/factories/mage_factory.rb'
  require '/app/factories/archmage_factory.rb'
  require '/app/factories/steelclad_factory.rb'
  require '/app/factories/adept_factory.rb'
  require '/app/factories/spell_factory.rb'
  #require '/app/init_siegeguy.rb'

  def initialize args
    # initialize each component container

    args.state.map = Array.new(20) { Array.new(20) }


    args.state.xforms                 = []
    args.state.anims                  = []
    args.state.sprites                = []
    args.state.spell_anims            = []
    args.state.spell_behaviors        = []
    
    #args.state.known_anims            = []
    args.state.behaviors              = []
    args.state.behavior_signals       = []
    args.state.anim_pail              = {}
    args.state.entity_id              = -1
    args.state.spell_id               = -1

    # REGARDING ENT IDS: currently we are looping through arrays, with ID as index.
    # to avoid running out of ids, have separate ids for temporary things
    # can only have max # of temp things before we reset id to 0 (is the plan{nyi})

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
