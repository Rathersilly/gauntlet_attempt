require '/app/init.rb'
require '/app/ents.rb'
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state
  def defaults
    state.guy ||= Guy.new(position: {x:1,y: 4},
                          name: "Boris",sprite: 'sprites/misc/dragon-0.png')
    state.enemy ||= Guy.new(position: {x:12,y: 4},
                            name: "fhjksdfhaj",sprite: 'sprites/hexagon/green.png')
    state.ents ||= []
  end

  def tick
    defaults
    render
    calc
    cleanup
    input

  end

  def render
    render_guys

  end

  def render_guys
    state.guy.draw args
    state.enemy.draw args
    state.ents.each {|ent| ent.draw args}

  end
  def calc
    state.ents.each {|ent| ent.calc}
  end
  def cleanup
    state.ents = state.ents.reject do |ent|
      ent.x < 0 || ent.x > 1280 ||ent.y < 0 || ent.y > 720
    end
  end


  def input
    if inputs.mouse.down
      new_bullet = Bullet.new(state.guy.x*Gsize + Gsize,state.guy.y*Gsize)
      new_bullet.set_dest(*inputs.mouse.point)
      state.ents << new_bullet
      #state.ents << Bullet.new(*inputs.mouse.down.point)
      puts state.ents
      puts inputs.mouse.down.point
    end
  end
end



$game = Game.new
def tick args
  $game.args = args
  $game.grid = args.grid
  $game.inputs = args.inputs
  $game.outputs = args.outputs
  $game.state = args.state
  $game.tick
end
