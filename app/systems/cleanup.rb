class Cleanup < System
  def tick args, reg
    return
    super
    @view[Behavior_signal].reject! { |bs| bs.handled == true }
  end
end

