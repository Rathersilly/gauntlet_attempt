class Factory
  class << self
    def create(args, **opts)
      before args, opts
      @x          = opts[:x]       || 200
      @y          = opts[:y]       || 200
      @w          = opts[:w]       || 100
      @h          = opts[:h]       || 100
      @color      = opts[:color]
      @spell ||= false
      if @spell
        @ent      = new_spell_id args
        puts "CREATED SPELL: id##{@ent} @ #{@x}, #{@y}"
      else
        @ent      = new_entity_id args
        puts "CREATED BEING: id##{@ent} @ #{@x}, #{@y}"
      end





      xform args
      anim args
      behavior args
      after args
    end

    def new_entity_id args
      args.state.entity_id += 1
    end

    def new_spell_id args
      args.state.spell_id += 1
    end

    def xform args
      # this is overridden in SpellFactory class
      args.state.xforms[@ent] = {x: @x, y: @y, w: @w, h: @h}
    end
    def before args, opts
      # override this in subclass if needed
    end
    def after args
      # override this in subclass if needed
      p self
      p args.state.xforms[@ent]
    end
    def anim args
      # override this in subclass if needed
    end
    def behavior args
      # override this in subclass if needed
    end


  end
end

