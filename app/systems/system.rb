class System
  attr_accessor :reads, :writes

  def initialize
    puts "INIT ANIM(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((".red
    @reads = []
    @writes = []
  end
  def requires
    @reads + @writes
  end

  def tick args, reg
    # need to return 
    @view = reg.view
    # puts "SYSTEM TICK".cyan
    # puts self.class
    # puts (!@view.keys.include? self.class)
    #if !@view.keys.include? self.class
  end

end 
