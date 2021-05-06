#require '/app/init.rb'
require '/app/ents.rb'
#require '/app/anim.rb'
#require '/app/attack.rb'

# OK first try at implementing Entity Component System.
# dragonruby already does a big part of it with the render class
# ruby has modules and singleton class, which should make this elegant
# you got this.
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state

  def initialize args
    # initialize each component container

    args.state.xforms       = []
    args.state.anims        = []
    args.state.known_anims  = []
    args.state.behavior     = []
    args.state.behavior_signals     ||= []
    args.state.anim_pail    = {}

    # REGARDING ENT IDS: currently we are looping through arrays, with ID as index.
    # to avoid running out of ids, have separate ids for temporary things
    # can only have max # of temp things before we reset id to 0 (is the plan{nyi})

    @@ent_id          = -1    # these start at -1 because they are incremented for each
    @@temp_ent_id     = -1    # new ent, and we want the component arrays to start at 0
    init_anims args
    init_hero args
  end

  def new_ent_id
    @@ent_id += 1
  end

  def new_temp_ent_id
    @@temp_ent_id += 1
  end

  def init_hero args
    #args.state.hero = Ent.new
    ent = new_ent_id

    # xform
    args.state.xforms[ent] = Xform.new(ent: ent,x: 200,y:200,w:200,h:200)
    #args.state.xforms[ent] = [x: 200,y:200,w:200,h:200]

    # anim
    # this might be a tad confusing (or not)
    # args.state.known_anims is an array of hashes, which are found by the index ent
    args.state.known_anims[ent] = {}
    anim = args.state.anim_pail[:hero_attack_staff].dup
    anim.ent = ent
    args.state.known_anims[ent][anim.name] = anim

    anim = args.state.anim_pail[:hero_idle].dup
    anim.ent = ent
    args.state.known_anims[ent][anim.name] = anim

    # set anim to play
    args.state.anims << anim

    # behaviour
    b = Behavior.new(ent: ent)

    # needs to have default behavior (eg idle anim)
    b.define_singleton_method(:default_anim) do |args|
      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      anim = args.state.known_anims[@ent][:hero_idle]

      # check if an animation with this ent is playing
      if args.state.anims.select { |anim| anim.ent == ent }

        args.state.anims[ent] = anim
      end
    end

    # needs to have a trigger (eg input) which has some effect (eg change anim)
    b.define_singleton_method(:on_mouse_down) do  |args|
      # animation becomes attack

      # reset animation
      args.state.anims.reject! {|x| x.ent == ent }
      args.state.anims << args.state.known_anims[ent][:hero_attack_staff]

    end

    # would like the attack method to invoke the on_mouse_down method,
    # not the other way around
    # if it could be registered or something?
    b.define_singleton_method(:attack) do 
    end

    args.state.hero = ent
    args.state.behavior[ent] = b
  end

  def init_anims args

    anim = Anim.new(name: :hero_idle, loop: true)
    (1..9).each do |i|
      anim << "sprites/archmage/arch-mage+female-idle-#{i}.png"
    end
    anim.duration = 120
    args.state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

    anim = Anim.new(name: :hero_attack_staff)
    (1..2).each do |i|
      anim << "sprites/archmage/arch-mage+female-attack-staff-#{i}.png"
    end
    p "!!!!!!!!!!!!!!!!!!!!!!"
    args.state.anim_pail[anim.name] = anim
    puts "Adding anim to pail:"
    anim.inspect

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
    state.anims.reject! do |anim|
      if anim.state == :done 
        # this dependency sucks - would be better to have a callback of some kind
        anim.reset
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
