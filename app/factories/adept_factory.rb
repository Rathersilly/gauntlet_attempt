class AdeptFactory < Factory
  class << self

    def before args, opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
    end

    def xform args, **opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      Xform.new(x: @x, y: @y, w: @w, h: @h)
    end

    def anim_store args, **opts
      anims =[] 

      anims_to_add = %i[adept_idle adept_magic]

      anims_to_add.each do |name|
        anim = args.state.all_anims[name].dup
        anims << anim
        anim.flip_horizontally = true
      end
      AnimStore.new anims

    end

    def behavior args, **opts
      b = AdeptBehavior.new
    end

  end
end

class AdeptBehavior < Behavior


end
