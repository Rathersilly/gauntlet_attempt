class Cleanup < System
  def initialize
    super
    @writes += [BehaviorSignal]
  end
  def tick args, reg
    super
    # puts "CLEANUP".red
    # p @view[BehaviorSignal]
    @view[BehaviorSignal].reject! { |bs| bs.handled == true }
  end
end

