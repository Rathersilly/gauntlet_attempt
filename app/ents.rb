# THE STATE OF ENTITIES:
# so, ENT is superclass that is used to instantiate new collections
# of components.  It is not an entity in a classical inheritance way.
# there's a better way to describe this =\

# The Ent class is more of a factory for components, which are linked
# by an entity_id integer.

class Ent 
  def new_entity_id args
    args.state.entity_id += 1
  end

  # this might be used in future - thought about having separate id indexes for temporary ents
  def new_tent_id args
    args.state.tent_id += 1
  end

end


