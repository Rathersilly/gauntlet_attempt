class RenderSprites < System
  def initialize
    super
    @reads += [Xform, Frame]
  end

  def tick args, reg
    super
    render_sprites args
    #render_labels args
  end

  def render_sprites args
    p @view[Frame]
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

