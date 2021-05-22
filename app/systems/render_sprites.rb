class RenderSprites < System
  def initialize
    super
    @reads += [Xform, Frame]
  end

  def tick args, reg
    super
    render_trees args
    render_sprites args
    #render_labels args
  end
  def render_trees args
    midx = 1280/2
    midy = 720/2
    trees = []
    12.times do |i|
      trees << {path:'sprites/scenery/oak-leaning.png',
                x: 200+ i*100,y:midy, w:200,h:200}
      trees << {path:'sprites/scenery/oak-leaning.png',
                x: 200+ i*100,y:midy-200, w:200,h:200}
    end
    args.outputs.sprites << trees
    # args.outputs.sprites << {path:'sprites/scenery/oak-leaning.png',
    #                                 x: midx-200,y:midy-200, w:200,h:200}
  end

  def render_sprites args
    # puts "render sprites".red
    # p @view[Frame]
    # puts "RENDER SPRITES".blue
    args.outputs.sprites << @view[Xform].map.with_index do |xf, i|
      next unless @view[Frame][i]
      # puts @view[Frame][i].angle
      # p xf.to_h.merge(@view[Frame][i])
      xf.to_h.merge(@view[Frame][i])
    end
  end

  def render_labels args
    args.outputs.labels << [100,40, "#{@registry.anims[1].cur_time}"]
    args.outputs.labels << [100,60, "#{@registry.anims[1].frame_duration}"]
    args.outputs.labels << [100,80, "#{@registry.anims[1].frame_index}"]
    args.outputs.labels << [100,100, "#{@registry.anims[1].duration}"]
  end
end

