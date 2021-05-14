class ComponentStore
  # each ComponentStore has its own set of ids
  # can set @max_ids to limit entities for better perf
  
  # each of these is an array, where index = entity_id.
  # the mechanism for adding multiple behaviors is to use modules
  # although, gonna need containers for anims anyway

  # this class might also keep track of the active component of each
  # collection - or delegate that to behavior?
  attr_accessor :id, :max_ids, :xforms, :anims, :behaviors, :behavior_signals
  attr_accessor :active_xforms, :active_anims, :active_behaviors
  attr_accessor :anim_stores

  def initialize
    @xforms = []
    @anims = []
    @anim_stores = []
    @behaviors = []
    @behavior_signals = []
    @id = -1
    @max_ids = nil
  end

  def << **components
    id = new_entity_id
    @xforms[id] = components[:xform]
    @behaviors[id] = components[:behavior]

    @anim_stores[id] = components[:anim_store]
    if @anim_stores[id].empty?
      @anims[id] = nil
    else
      @anims[id] = @anim_stores[id][0]
    end
    
    init_components id, components
  end

  def init_components id, **components
    print "INITIALIZING COMPONENTS: ".green
    p components
    components.each_value do |component|
      if component.class.ancestors.include?(Component)
        component.ent = id
        component.container = self
      end
      if component.class == Array
        component.each do |subcomponent|
          subcomponent.ent = id
          subcomponent.container = self
        end
      end
    end
    # puts "ANIMS ID"
    # p @anims[id].ent
    # p @anims[id].container
  end

  def components
  end

  def new_entity_id
    @id += 1
    if @max_ids && @id == @max_ids
      # might need function to clear out this id - not all components might get overwritten
      @id = 0
    end
    @id
  end

  def inspect
    puts "inspecting Store"
    p @xforms
    p @anim_stores
    p @anims
    p @behaviors
  end

end

