require '/app/ents.rb'
require '/app/init.rb'
#require '/app/anim.rb'
#require '/app/attack.rb'

# OK first try at implementing Entity Component System.
# dragonruby already does a big part of it with the render class
# ruby has modules and singleton class, which should make this elegant
# you got this.
module Init
end
class Game
  attr_gtk
  #attr_accessor :args, :grid, :inputs, :outputs, :state

  include Init

  def new_entity_id args
    args.state.entity_id += 1
  end

  def initialize args
    # initialize each component container

    args.state.xforms                 = []
    args.state.anims                  = []
    args.state.effects                = []
    args.state.tents                  = []
    #args.state.known_anims            = []
    args.state.behaviors              = []
    args.state.behavior_signals       = []
    args.state.anim_pail              = {}
    args.state.entity_id              = -1
    args.state.tent_id                = -1

    # REGARDING ENT IDS: currently we are looping through arrays, with ID as index.
    # to avoid running out of ids, have separate ids for temporary things
    # can only have max # of temp things before we reset id to 0 (is the plan{nyi})

    @args = args
    @state = args.state
    @grid = args.grid
    @outputs = args.outputs
    @inputs = args.inputs
    init_anims 
    #init_hero args
    MageFactory.create args
    args.state.hero = 0
    SteelCladFactory.create args, {x: 700,y:400}
    AdeptFactory.create args, {x: 900,y:400}
    
    #init_siegeguy args
  end

  def new_tent_id 
    args.state.tent_id += 1
  end


  def tick
    # run through systems. each system invokes one or more components
    # I think input is not necessary - dragonruby basically takes care of that
    behavior
    render
    cleanup
  end

  def behavior
    #puts "BEHAVIOR"
    # iterate through state.behavior_signals, to see if any behaviors must respond
    # eg to finished animations

    if !state.behavior_signals.empty?
      puts "STATE BEHAVIOR SIGNALS"
      p state.behavior_signals
      state.behavior_signals.each do |bs|
        state.behaviors.each do |b|
          if b.ent == bs.ent
            b.handle(bs, args)
          end
        end
      end
    end

    # iterate through behavior components, see if they respond to input


    # uh, this isnt currently used - maybe delete?
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

    # there's probably a better way to iterate here - maybe a container
    # with all the behaviors that respond to input
    if inputs.mouse.down
      state.behaviors.each do |b|
        b.send(:on_mouse_down, args) if b.respond_to?(:on_mouse_down)
      end
    end

    # puts "key_down"
    # p inputs.keyboard.key_down
    # puts "key_down_or_held"
    # p inputs.keyboard.key_down_or_held
    state.behaviors.each do |b|
      b.send(:on_key_down, args) if b.respond_to?(:on_key_down)
      # this was in a separate each loop - probably fine to keep it here?
      b.send(:on_tick, args) if b.respond_to?(:on_tick)
    end

  end

  def render
    #outputs.labels << [400,680,"HITPOINTS: #{state.hero.hp}",5]
    #outputs.labels << [400,640,"STATUS: #{state.hero.status}",5]
    #outputs.sprites << [500,300,200,200,'sprites/square/violet.png',45,255,0,255,255]
    #outputs.solids << [500,300,200,200,45,255,0,255,255]
    #puts "RENDER"
    render_background

    state.anims.each do |anim|
      next if anim.nil? || anim.state == :done
      anim.render args 
    end
    state.effects.each do |anim|
      next if anim.nil? || anim.state == :done
      anim.render args 
    end
    
    outputs.labels << [10,700, "#{args.gtk.current_framerate.round}"]
  end

  def render_background
    outputs.background_color = Yellow
  end

  def cleanup
    # puts "CLEANUP"
    # p state.anims
    # p state.effects
    state.anims.reject! do |anim|
      #puts "CHECKING ANIM"
      #puts anim.state
      truthflag = false
      if anim.state == :done 
        truthflag =  true
      end
      truthflag
    end

    state.effects.reject! do |anim|
      truthflag = false
      if anim.state == :done 
        truthflag =  true
      end
      truthflag
    end

    state.behavior_signals.reject! { |bs| bs.handled == true }
  end



end

def tick args
  $game ||= Game.new args
  $game.args = args
  $game.tick
  #args.outputs.background_color = [100,100,100]
  #args.outputs.solids <<  [0,0,1280,720,100,100,100]
end
