module InitWorld
  # The initialize function of World class

  def initialize args

    init_systems args
    init_registries args
    init_level args

    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs

    args.state.all_anims  = {}
    init_anims 

    args.state.teams = {player: Team.new(name: :player), enemy: Team.new(name: :enemy)}

    args.state.misc << TriggerFactory.create(args, x:400,y:0,w:1,h: 720)

    args.state.mobs << SorceressFactory.create(args, x: 100, y: 400, team: args.state.teams[:player])
    # Mobs << MageFactory.create(args, team: Teams[:player])
    args.state.hero = 0
    #Mobs << AdeptFactory.create(args, {x: 900,y:400})
    # Mobs << DoodadFactory.create(args, x: 300, y: 300)
    0.times do |i|
      args.state.mobs << SteelcladFactory.create(args, x: rand(1280),y:rand(720),
                                                 team: args.state.teams[:enemy])
    end

    args.state.mobs << SteelcladFactory.create(args, x: 400,y:200, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 400,y:400, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 600,y:200, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 600,y:400, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 800,y:200, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 800,y:400, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 1000,y:200, team: args.state.teams[:enemy])
    args.state.mobs << SteelcladFactory.create(args, x: 1000,y:400, team: args.state.teams[:enemy])

    # args.state.mobs << Spawner.create(args, x: 300, y: 300, team: args.state.teams[:enemy])
    # args.state.mobs << Spawner.create(args, x: 900, y: 100, team: args.state.teams[:enemy])
    # args.state.mobs << Spawner.create(args, x: 900, y: 600, team: args.state.teams[:enemy])
    # args.state.mobs << Spawner.create(args, x: 600, y: 100, team: args.state.teams[:enemy])
    # args.state.mobs << Spawner.create(args, x: 600, y: 600, team: args.state.teams[:enemy])

    # darken map effect - ie during pause
    args.state.darken = false

    create_map args
    render_map args
    init_trees args
    render_trees args
    puts "END OF INIT WORLD".green
    # p Registries
  end

  def init_systems args
    args.state.systems = {}
    args.state.systems[:anim] = AnimSystem.new
    args.state.systems[:behavior] = BehaviorSystem.new
    args.state.systems[:health] = HealthSystem.new
    #args.state.systems[:render_solids]  = RenderSolids.new
    # args.state.systems[:render_static_solids]  = RenderStaticSolids.new
    args.state.systems[:render_sprites] = RenderSprites.new
    args.state.systems[:cleanup] = Cleanup.new
  end

  def init_registries args
    args.state.spells = ComponentRegistry.new do |cr|
      cr.name = "Spells"
      cr.create_view Xform, Anim, Behavior, Collider, Team
      cr.max_ids = 10
    end

    args.state.mobs = ComponentRegistry.new do |cr|
      cr.name = "Mobs"
      cr.create_view Xform, Anim, Behavior, Collider, Team, Health
    end

    args.state.map = ComponentRegistry.new do |cr|
      cr.name = "Map"
      cr.create_view Xform, Color, Frame
    end

    args.state.misc = ComponentRegistry.new do |cr|
      cr.name = "Misc"
      cr.create_view Xform, Collider, Behavior, Team
    end



    args.state.registries = []
    args.state.registries << args.state.spells
    args.state.registries << args.state.mobs
    args.state.registries << args.state.map
    args.state.registries << args.state.misc
    # puts "END INIT REG".magenta
    # p args.state.mobs
    # p args.state.spells
    # p args.state.registries
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
        args.state.map << tile 
      end
    end

  end

  def render_map args
    RenderStaticSolids.new.tick args, args.state.map
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

  def init_level args
    args.state.events = {}
    args.state.events[:game_start] = Level1::GameStart.new(args)
    args.state.events[:trigger_polite] = Level1::TriggerPolite.new(args)
    args.state.events[:trigger_stern] = Level1::TriggerStern.new(args)
    args.state.events[:trigger_missile] = Level1::TriggerMissile.new(args)
  end
end

