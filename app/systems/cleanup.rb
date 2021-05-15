class Cleanup < System
  def tick args, reg
    super
    @registry.behavior_signals.reject! { |bs| bs.handled == true }
  end
end

