require '/app/init.rb'
require '/app/ents.rb'
#require '/app/anim.rb'
#require '/app/attack.rb'

# OK first try at implementing Entity Component System.
# dragonruby already does a big part of it with the render class
# ruby has modules and singleton class, which should make this elegant
# you got this.
module Init
end
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state

  include Init
  def initialize args
    # initialize each component container

    args.state.xforms                 = []
    args.state.anims                  = []
    #args.state.known_anims            = []
    args.state.behavior               = []
    args.state.behavior_signals       = []
    args.state.anim_pail              = {}

    # REGARDING ENT IDS: currently we are looping through arrays, with ID as index.
    # to avoid running out of ids, have separate ids for temporary things
    # can only have max # of temp things before we reset id to 0 (is the plan{nyi})

    @@ent_id          = -1    # these start at -1 because they are incremented for each
    @@temp_ent_id     = -1    # new ent, and we want the component arrays to start at 0
    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs
    init_anims 
    init_hero args
    init_baddie args
  end

  def new_ent_id
    @@ent_id += 1
  end

  def new_temp_ent_id
    @@temp_ent_id += 1
  end

  def tick
    # run through systems. each system invokes one or more components
    # I think input is not necessary - dragonruby basically takes care of that
    behavior
    render
    cleanup
  end

  def behavior
    # iterate through state.behavior_signals, to see if any behaviors must respond
    # eg to finished animations

    if !state.behavior_signals.empty?
      puts "STATE BEHAVIOR SIGNALS"
      p state.behavior_signals
      state.behavior_signals.each do |bs|
        state.behavior.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end
    
    # iterate through behavior components, see if they respond to input
    
    # default doesnt have to be called every frame - it should respond to signal,
    # or be called by itself after finishing a task perhaps
    
    state.behavior.each do |b|
      #b.default
    end

    if inputs.keyboard.key_down.one
      state.anims.reject! {|x| x.name == :hero_attack_staff }
      anim = state.anim_pail[:hero_idle].dup
      anim.ent = state.hero
      state.anims << anim if state.anims.none? { |x| x.name == :hero_idle }
    elsif inputs.keyboard.key_down.two
      state.anims.reject! {|x| x.name == :hero_idle }
      anim = state.anim_pail[:hero_attack_staff].dup
      anim.ent = state.hero
      state.anims << anim if state.anims.none? { |x| x.name == :hero_attack_staff }
    end
    if inputs.mouse.down
      state.behavior.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end

      #attack animation
    end

  end

  def render
    #outputs.labels << [400,680,"HITPOINTS: #{state.hero.hp}",5]
    #outputs.labels << [400,640,"STATUS: #{state.hero.status}",5]
    #outputs.sprites << [500,300,200,200,'sprites/square/violet.png',45,255,0,255,255]
    #outputs.solids << [500,300,200,200,45,255,0,255,255]

    args.state.anims.each do |anim|
      next if anim.nil? || anim.state == :done
      anim.render args 
    end
  end

  def render_background
    outputs.background_color = Yellow
  end

  def cleanup
    puts "CLEANUP"
    p state.anims
    state.anims.reject! do |anim|
      if anim.state == :done 
        return true
      end
    end
    state.behavior_signals.clear
  end



end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.grid = args.grid
  $game.inputs = args.inputs
  $game.outputs = args.outputs
  $game.state = args.state
  $game.tick
  #args.outputs.background_color = [100,100,100]
  #args.outputs.solids <<  [0,0,1280,720,100,100,100]
end
