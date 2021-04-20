require '/app/init.rb'
require '/app/ents.rb'
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state
  def defaults
    state.guy ||= Ent.new(x:200,y: 720/2,w:80,h:80,
                          path: 'sprites/misc/dragon-0.png', speed: 10)
    state.enemy ||= Ent.new(x:1100,y: 720/2,w:150,h:150,
                            path: 'sprites/hexagon/green.png')
    state.ents ||= []
    state.burst_timer_max ||= 60
    state.burst_timer ||= 120
    state.background_color ||= [200,100,100]#[0,0,0]
    state.new_background_color ||= [0,0,0]
  end
;
  def tick
    defaults
    render
    calc
    cleanup
    input

  end

  def render
    render_background
    render_guys

  end
  def render_background
    while state.new_background_color == state.background_color
      state.new_background_color = Colors.sample
    end
    state.background_color.each_index do |i|
      if state.background_color[i] < state.new_background_color[i]
        state.background_color[i] += 1
      end
      if state.background_color[i] > state.new_background_color[i]
        state.background_color[i] -= 1
      end
    end
    outputs.background_color = state.background_color
  end

  def render_guys
    state.guy.draw args
    state.enemy.draw args
    state.ents.each {|ent| ent.draw args}

  end
  def calc
    state.ents.each {|ent| ent.calc}
    state.guy.calc
    if state.burst_timer == 0
      state.burst_timer = state.burst_timer_max
      burst
    else
      state.burst_timer -= 1
    end
    
  end

  def cleanup
    state.ents = state.ents.reject do |ent|
      ent.x < 0 || ent.x > 1280 ||ent.y < 0 || ent.y > 720
    end
  end

  def burst
   8.times do |i|
     angle = i*22.5 + 90 + rand(22)


     new_bullet = Bullet.new({x:state.enemy.x,y: state.enemy.y})
     new_bullet.angle = angle

     state.ents << new_bullet
   end
  end

  def input
    if inputs.mouse.down
      new_bullet = Bullet.new(x:state.guy.x,y:state.guy.y)
      new_bullet.set_dest(*inputs.mouse.point)
      state.ents << new_bullet
      #state.ents << Bullet.new(*inputs.mouse.down.point)
      #puts state.ents
      #puts inputs.mouse.down.point
    end
    if inputs.keyboard.key_held.w
      state.guy.y += state.guy.speed
    end
    if inputs.keyboard.key_held.a
      state.guy.x -=  state.guy.speed
    end
    if inputs.keyboard.key_held.s
      state.guy.y -= state.guy.speed
    end
    if inputs.keyboard.key_held.d
      state.guy.x +=  state.guy.speed
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
  #args.outputs.background_color = [100,100,100]
  #args.outputs.solids <<  [0,0,1280,720,100,100,100]
end
