require '/app/init.rb'
require '/app/ents.rb'
class Game
  attr_accessor :args, :grid, :inputs, :outputs, :state
  def defaults
    state.guy ||= Ent.new(x:200,y: 720/2,w:80,h:80,
                          #path: 'sprites/sylph.png', speed: 10)
                          path: 'sprites/siegetrooper.png', speed: 10)
    state.enemy ||= Ent.new(x:1100,y: 720/2,w:150,h:150,
                            path: 'sprites/fire-dragon.png',
                            flip_h: true)
    state.bad_ents ||= []
    state.good_ents ||= []
    state.explosions ||= []
    state.burst_timer_max ||= 60
    state.burst_timer ||= 120
    state.background_color ||= [200,100,100]
    state.new_background_color ||= [0,0,0]
  end

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

    outputs.labels << [300,680,"HITPOINTS: #{state.guy.hp}",5]
    outputs.labels << [300,640,"STATUS: #{state.guy.status}",5]
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
    state.bad_ents.each {|ent| ent.draw args}
    state.good_ents.each {|ent| ent.draw args}
    state.explosions.each do |exp|
      exp[:path] =  "sprites/fire-burst-small-#{exp[:age].floor}.png"
      outputs.sprites << exp
    end

  end
  def calc
    state.bad_ents.each {|ent| ent.calc}
    state.good_ents.each {|ent| ent.calc}
    state.explosions.each do |exp|
      exp[:age] += 0.25
    end
    state.guy.calc
    if state.burst_timer == 0
      state.burst_timer = state.burst_timer_max
      burst
    else
      state.burst_timer -= 1
    end
    check_collision
    
  end
  def check_collision
    state.bad_ents.each do |ent|
      if ent.rect.intersect_rect? state.guy.hitbox
        if state.guy.status == :normal
          state.guy.hp -= 1
          state.guy.status = :invincible
        end

        state.guy.invincible_timer = state.guy.invincible_length
        ent.status = :remove
        state.explosions << {x:ent.x,y:ent.y,w:30,h:30,path: "sprites/fire-burst-small-1.png",age:1}
      end

    end
  end

  def cleanup
    state.bad_ents = state.bad_ents.reject do |ent|
      ent.x < 0 || ent.x > 1280 ||ent.y < 0 || ent.y > 720 || ent.status == :remove
    end
    state.good_ents = state.good_ents.reject do |ent|
      ent.x < 0 || ent.x > 1280 ||ent.y < 0 || ent.y > 720|| ent.status == :remove
    end
    state.explosions.reject! do |exp|
      exp[:age] > 8
    end

  end

  def burst
   8.times do |i|
     angle = i*22.5 + 90 + rand(22)
     new_bullet = Bullet.new({x:state.enemy.x,y: state.enemy.y,
                              path: 'sprites/fire-burst-small-2.png',
                              angle: angle })
     state.bad_ents << new_bullet
   end
  end

  def input
    if inputs.mouse.down
      new_bullet = Bullet.new(x:state.guy.x,y:state.guy.y,
                              path: 'sprites/icemissile-ne-2.png',
                              speed: 14)
      new_bullet.set_dest(*inputs.mouse.point)
      state.good_ents << new_bullet
      state.guy.anim_state = :attack
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
