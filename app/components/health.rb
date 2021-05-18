class Health < Component
  attr_accessor :health

  def initialize(**opts)
    super
    @health = opts[:health] || 1
  end

end

