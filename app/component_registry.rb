class ComponentRegistry
  # each ComponentRegistry has its own set of ids
  # set @max_ids to limit entities for better perf

  # @view is a hash of arrays, one array for each component type
  # these arrays have index = component's entity_id
  attr_accessor :id, :max_ids, :name, :view

  def initialize
    @view = {}
    yield self

    @view[BehaviorSignal] = [] if @view.keys.include? Behavior
    if @view.keys.include? Anim
      @view[AnimGroup] = []
      @view[Frame] = []
    end

    puts "InitComponentRegistry:".cyan
    puts "\t- name: #{@name}"
    puts "\t- views: #{@view}"
    puts "\t- max_ids: #{@max_ids}\n"

    @name ||= "unnamed registry"
    @id = -1
    @max_ids ||= nil
  end

  def create_view(*types)
    types.each do |t|
      @view[t] = []
    end
    # puts 'VIEWING'.magenta
    # p @view
  end

  def views? requirements
    requirements.each do |item|
      return false unless @view.keys.include? item
    end
    true
  end

  def [] component
    @view[component]
  end

  def <<(**components)
    id = new_entity_id
    # puts '<<<<<<<<<<<<<<<<<'.cyan

    components.each do |k, v|
      @view.each do |type, container|
        if v.class.ancestors.include? type
          container[id] = v
        else

          # handle misc components - send them to a hash prob
          # or maybe make a subclass that can handles such things
        end
      end
    end
    # p @view
    # p id
    if  @view[Frame] && @view[Frame][id]
      @view[Frame][id] = @view[Frame][id].to_h
      # @view[Anim][id] = nil
      # puts "FRAME".green
      # p @view[Frame][id] 
    end
    if @view[AnimGroup] && @view[AnimGroup][id]
      @view[Anim][id] = @view[AnimGroup][id][0]
    end

    init_components id, components
  end

  def init_components(id, **components)
    # Set each component's @id and @container
    
    # print 'INITIALIZING COMPONENTS: '.green
    # p components
    components.each_value do |component|
      if component.class.ancestors.include?(Component)
        component.ent = id
        component.container = self
      end

      # Initialize a component's subcomponents
      if component.class.ancestors.include?(Behavior)
        # puts "INITIALIZING SUB_BEHAVIORS".green
        # p component.sub_behaviors
        component.sub_behaviors.each_value do |b|
          b.ent = id
          b.container = self
        end
        # puts "INITIALIZED".blue
        # p component.sub_behaviors
        # p component.sub_behaviors[0].ent rescue nil
        # p component.sub_behaviors[0].container rescue nil
      elsif component.instance_of?(AnimGroup)
        component.anims.each do |anim|
          anim.ent = id
          anim.container = self
        end
      end
    end
  end

  def delete ent
    # puts "DELETING #{ent} from #{name}".red
    @view.each_key do |type|
      # puts "Before"
      # p type
      # p @view[type][ent]
      @view[type][ent] = nil
      # puts "AFTER"
      # p @view[type][ent]
    end
    # puts "DELETED".red
    # p @view[Anim][ent]
    # p @view[Xform][ent]
  end

  def new_entity_id
    @id += 1
    if @max_ids && @id == @max_ids
      @id = 0
    end
    @id
  end

  def inspect
    puts "inspecting Registry \"#{@name}\" @view:".cyan
    @view.each do |k,v|
      puts "#{k}:\t #{v}"
    end
  end
end
