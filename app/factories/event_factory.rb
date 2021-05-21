class EventFactory < Factory


  class << self
    
    def behavior args, opts
      EventBehavior.new
    end

  end
end


class EventBehavior < Behavior
  attr_accessor


  def initialize **opts
  end

  def on_tick args

  end

end
