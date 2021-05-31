class Factory
  class << self

    def create args, **opts
      before args, opts
      {
        xform: xform(args, opts),
        anim_group: anim_group(args, opts),
        anim: anim(args, opts),
        behavior: behavior(args, opts),
        collider: collider(args, opts),
        color: color(args,opts),
        frame: frame(args,opts)
      }
    end

    # override these in subclass as needed
    def before args, opts
    end
    def xform args, opts
    end
    def anim_group args, opts
    end
    def anim args, opts
    end
    def frame args, opts
    end
    def behavior args, opts
    end
    def collider args, opts
    end
    def color args, opts
    end
    def health args, opts
    end

  end
end

