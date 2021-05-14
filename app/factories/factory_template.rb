class Factory
  class << self

    def create(args, **opts)
      before args, opts
      {
        xform: xform(args, opts),
        anim_store: anim_store(args, opts),
        behavior: behavior(args, opts)
      }
    end

    # override these in subclass as needed
    def before args, opts
    end
    def xform args, opts
    end
    def anim_store args, opts
    end
    def anim args, opts
    end
    def behavior args, opts
    end

  end
end

