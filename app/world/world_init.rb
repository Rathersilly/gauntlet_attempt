module InitWorld
  # The initialize function of World class

  def initialize args

    init_systems
    init_registries

    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs

    Teams = {player: Team.new(name: :player), enemy: Team.new(name: :enemy)}

    args.state.mobs       = Mobs
    args.state.spells     = Spells
    args.state.teams      = Teams
    args.state.misc       = Misc

    args.state.all_anims  = {}
    init_anims 

    Misc << TriggerFactory.create(args, x:400,y:0,w:1,h: 720)

    Mobs << SorceressFactory.create(args, x: 100, y: 400, team: Teams[:player])
    # Mobs << MageFactory.create(args, team: Teams[:player])
    args.state.hero = 0
    #Mobs << AdeptFactory.create(args, {x: 900,y:400})
    # Mobs << DoodadFactory.create(args, x: 300, y: 300)
    0.times do |i|
      Mobs << SteelcladFactory.create(args, x: rand(1280),y:rand(720),
                                      team: Teams[:enemy])
    end

    sc = SteelcladFactory.create(args, x: 300,y:300,
                                      team: Teams[:enemy])
    Mobs << sc
    Mobs[Anim][-1]

    # Mobs << Spawner.create(args, x: 300, y: 300, team: Teams[:enemy])
    # Mobs << Spawner.create(args, x: 900, y: 100, team: Teams[:enemy])
    # Mobs << Spawner.create(args, x: 900, y: 600, team: Teams[:enemy])
    # Mobs << Spawner.create(args, x: 600, y: 100, team: Teams[:enemy])
    # Mobs << Spawner.create(args, x: 600, y: 600, team: Teams[:enemy])

    create_map args
    render_map args
    init_trees args
    render_trees args
    puts "END OF INIT WORLD".green
    # p Registries
  end

  def init_systems
    Systems = []
    Systems << AnimSystem.new
    Systems << BehaviorSystem.new
    Systems << HealthSystem.new
    #Systems << RenderSolids.new
    # Systems << RenderStaticSolids.new
    Systems << RenderSprites.new
    Systems << Cleanup.new
    $systems = Systems
  end

  def init_registries
    Spells = ComponentRegistry.new do |cr|
      cr.name = "Spells"
      cr.create_view Xform, Anim, Behavior, Collider, Team
      cr.max_ids = 10
    end

    Mobs = ComponentRegistry.new do |cr|
      cr.name = "Mobs"
      cr.create_view Xform, Anim, Behavior, Collider, Team, Health
    end

    Map = ComponentRegistry.new do |cr|
      cr.name = "Map"
      cr.create_view Xform, Color, Frame
    end

    Misc = ComponentRegistry.new do |cr|
      cr.name = "Misc"
      cr.create_view Xform, Collider, Behavior, Team
    end


    Registries = []
    Registries << Map
    Registries << Mobs
    Registries << Spells
    Registries << Misc
  end

  def create_map args
    puts "Create map".cyan
    tile_size = 80
    16.times do |x|
      9.times do |y|
        color = Green
        if x == 0 || x == 15 || y == 0 || y == 8
          color = Brown
        end
        tile = BlockFactory.create(args, x:x* tile_size,y:y* tile_size,w:tile_size,h:tile_size,
                                   color: color)
        Map << tile 
      end
    end

  end

  def render_map args
    RenderStaticSolids.new.tick args, Map
    args.outputs.static_sprites << {x:13*80,y:4*80,w:80,h:80,path: 'sprites/scenery/downstairs.png'}

  end

  def init_trees args
    midx = 1280/2
    midy = 720/2
    args.state.trees = []
    12.times do |i|
      args.state.trees << {path:'sprites/scenery/oak-leaning.png',
                x: 200+ i*100,y:midy, w:200,h:200}
      args.state.trees << {path:'sprites/scenery/oak-leaning.png',
                x: 200+ i*100,y:midy-200, w:200,h:200}
    end
  end

  def render_trees args
    puts "render trees".blue
    args.outputs.static_sprites << args.state.trees
  end
end

