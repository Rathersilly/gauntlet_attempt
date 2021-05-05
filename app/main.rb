require '/app/init.rb'
require '/app/ents.rb'
require '/app/anim.rb'
#require '/app/attack.rb'

# OK first try at implementing Entity Component System.
# dragonruby already does a big part of it with the render class
# ruby has modules and singleton class, which should make this simple
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state

  def initialize
    state.mobs ||= []
    state.animations ||= []
    state.hero ||= init_hero
  end

  def tick
    calc
    render
    #cleanup
    #input
  end

  def calc
  end

  def render
    outputs.labels << [400,680,"HITPOINTS: #{state.hero.hp}",5]
    outputs.labels << [400,640,"STATUS: #{state.hero.status}",5]
  end

  def render_background
    outputs.background_color = Yellow
  end

end

def tick args
  $game ||= Game.new
  $game.args = args
  $game.grid = args.grid
  $game.inputs = args.inputs
  $game.outputs = args.outputs
  $game.state = args.state
  $game.tick
  #args.outputs.background_color = [100,100,100]
  #args.outputs.solids <<  [0,0,1280,720,100,100,100]
end
