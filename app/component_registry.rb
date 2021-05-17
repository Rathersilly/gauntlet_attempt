class ComponentRegistry
  # each ComponentRegistry has its own set of ids
  # set @max_ids to limit entities for better perf

  # @view is a hash of arrays, one array for each component type
  # these arrays have index = component's entity_id
  attr_accessor :id, :max_ids, :name, :view

  def initialize
    @view = {}
    yield self

    if @view.keys.include? Behavior
      @view[BehaviorSignal] = []
    end
    if @view.keys.include? Anim
      @view[AnimStore] = []
      @view[Frame] = []
    end
    puts "END INIT".cyan
    p @view
    p @view[AnimStore]
    @name ||= ""
    @id = -1
    @max_ids ||= nil
  end

  def create_view *types
    puts "VIEWING".magenta
    types.each do |t|
      @view[t] = []
    end
    p @view
    #create_accessors
  end

  def views? array
    array.each do |item|
      if !@view.keys.include? item
        return false
      end
    end
    true
  end
  # def create_accessors
  #   @view.each_key do |key|
  #   puts "<<<<<<<<<<<<<<<<<".green
  #     p key
  #     key = key.to_s.downcase.to_sym
  #     p key
  #     define_singleton_method key do
  #       @view[key]
  #     end
  #     key = key.to_s.concat("=").to_sym
  #     define_singleton_method key do |new_val|
  #       @view[key] = new_val
  #     end
  #   end
  # end

  def << **components
    id = new_entity_id
    puts "<<<<<<<<<<<<<<<<<".green

    components.each do |k,v|
      @view.each do |type, container|

        if v.class.ancestors.include? type
          container[id] = v
        else
          #handle misc components - send them to a hash prob
        end
      end
    end

    p @name
    p @view[AnimStore]
    p @view[AnimStore][id].anims
    if @view[AnimStore][id]
      @view[Anim][id] = @view[AnimStore][id][0]
      @view[Frame][id] = @view[Anim][id].frames[0]
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
      if component.class == AnimStore
        component.anims.each do |anim|
          anim.ent = id
          anim.container = self
        end
      end
    end
  end

  def new_entity_id
    @id += 1
    if @max_ids && @id == @max_ids
      # might need function to clear out this id - if not all components get overwritten
      @id = 0
    end
    @id
  end

  def inspect
    puts "inspecting Registry #{@name}"
    p @view
  end

end

