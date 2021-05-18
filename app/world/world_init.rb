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

    args.state.mobs       = Mobs
    args.state.spells     = Spells

    args.state.all_anims  = {}
    init_anims 
    
    Teams = {player: Team.new(name: :player), enemy: Team.new(name: :enemy)}

    Mobs << MageFactory.create(args, team: Teams[:player])
    args.state.hero = 0
    #Mobs << AdeptFactory.create(args, {x: 900,y:400})
    3.times do |i|
      Mobs << SteelCladFactory.create(args, x: rand(1280),y:rand(720), team: Teams[:enemy])
    end

    create_map
    render_map
  end

  def init_systems
    Systems = []
    Systems << Animation.new
    Systems << Behaviorsys.new
    #Systems << RenderSolids.new
    # Systems << RenderStaticSolids.new
    Systems << RenderSprites.new
    Systems << Cleanup.new
  end

  def init_registries
    Spells = ComponentRegistry.new do |cr|
      cr.name = "Spells"
      cr.create_view Xform, Anim, Behavior, Collider, Team
      cr.max_ids = 3 
    end

    Mobs = ComponentRegistry.new do |cr|
      cr.name = "Mobs"
      cr.create_view Xform, Anim, Behavior, Collider, Team, Health
    end

    Map = ComponentRegistry.new do |cr|
      cr.name = "Map"
      cr.create_view Xform, Color
    end

    Registries = []
    Registries << Map
    Registries << Mobs
    Registries << Spells
  end

  def create_map
    puts "Create map".cyan
    p Spells
    tile_size = 80
    16.times do |x|
      9.times do |y|
        tile = BlockFactory.create(args, x:x* tile_size,y:y* tile_size,w:tile_size,h:tile_size,
                                   r: rand(255),g:rand(255),b:rand(255))
        #p tile
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

