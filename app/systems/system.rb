class System

  def initialize
    # is view/filter even needed?
    @view = []
  end

  def tick args, reg
    @registry = reg
  end

end
