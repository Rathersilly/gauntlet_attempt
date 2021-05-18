class Collider < Component
  attr_accessor :xform, :offset

  def initialize(**optarray)
    super
      @xform = optarray[:xform]
      @offset = optarray[:offset]

  end

end
