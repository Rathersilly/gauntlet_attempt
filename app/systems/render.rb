class Render < System
  def initialize
    super
    @view << Xform
    @view << Frame

  end
  def tick args, reg
    super
    render_background args
    render_sprites args
    #render_labels args
  end

  def render_background args
    args.outputs.background_color = Yellow
  end

  def render_sprites args
    args.outputs.sprites << @registry.view[Xform].map.with_index do |xf, i|
      next unless @registry.view[Frame][i]
      xf.to_h.merge(@registry.view[Frame][i])
    end
  end

  def render_labels args
    args.outputs.labels << [100,40, "#{@registry.anims[1].cur_time}"]
    args.outputs.labels << [100,60, "#{@registry.anims[1].frame_duration}"]
    args.outputs.labels << [100,80, "#{@registry.anims[1].frame_index}"]
    args.outputs.labels << [100,100, "#{@registry.anims[1].duration}"]
  end
end

