# Contents: Behavior class, BehaviorSignal class
#
# again, logic can be moved out of here (mainly the set_dir function)
# every unnecessary function (or anything) defeats the point of components.
# like maybe even move the inspect function to some sort of helper class
# actually this needs massive refactor
class Behavior < Component
  # does behavior know about all its anims? or just loop through them as needed and select
  # the ones with the same ent

  # the current plan: add methods here to singleton class.  But have templates for things
  # that need to be repeated. or actually subclasses would work I think.
  attr_accessor :name, :enabled, :status
  def initialize(**opts)
    super
    @ent          = opts[:ent]         || nil
    @name         = opts[:name]        || "unnamed behavior"
    @default      = opts[:default]     || false
    @enabled      = opts[:enabled]     || true
    @status       = opts[:status]      || nil
  end

  def known_anims ent, name
    args.state.known_anims[ent][name].dup
  end

  # args as first arg would be more consistent, but who could resist?
  def handle bs, args
    #puts "HANDLING BEHAVIOR SIGNAL"
      #Tools.megainspect bs


    if bs.type == Anim && bs.state == :done
      default_anim args if methods.include?(:default_anim)
    elsif bs.type == Collider && bs.state == :done
    end


    bs.handled = true
  end

  def add_attribute name, value, access = true
    instance_variable_set("@#{name}", value)
    if access == true
      singleton_class.class_eval { attr_accessor name}
    end
  end

  def set_dest args, dest_vector
    @dest = dest_vector
  end

end

class BehaviorSignal < Component
  # when an animation finishes, it sets it state to :done (so it is cleaned up)
  # and places a BehaviorSignal instance in state.behavior_signals
  # which is looped through in the behavior system
  attr_accessor :ent, :type, :state, :info, :handled, :container, :message

  # types of BSignals: anim_finished

  def initialize(**opts)
    puts "BEHAVIOR SIGNAL CREATED"
    # type = :anim_done
    # info = eg anim name
    @ent          = opts[:ent]         || nil
    @type         = opts[:type]        || nil
    @state        = opts[:state]       || nil
    @info         = opts[:info]        || nil
    @message      = opts[:message]     || nil

    @target       = opts[:target]      || nil
    @handled      = opts[:handled]     || false
  end

end

