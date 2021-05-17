class RenderSolids < System
  def initialize
    super
    @reads += [Xform, Color]
  end

  def tick args, reg
    super
    render_background args
    render_solids args
    #render_labels args
  end

  def render_background args
    args.outputs.background_color = Yellow
  end

  def render_solids args
    args.outputs.solids << @view[Xform].map.with_index do |xf, i|
      xf.to_h.merge(@view[Color][i].to_h)
    end
  end

  def render_labels args
    args.outputs.labels << [100,40, "#{@registry.anims[1].cur_time}"]
    args.outputs.labels << [100,60, "#{@registry.anims[1].frame_duration}"]
    args.outputs.labels << [100,80, "#{@registry.anims[1].frame_index}"]
    args.outputs.labels << [100,100, "#{@registry.anims[1].duration}"]
  end
end

