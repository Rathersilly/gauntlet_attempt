class System
  attr_accessor :reads, :writes

  def initialize
    @reads = []
    @writes = []
  end
  def requirements
    @reads + @writes
  end

  def tick args, reg
    @view = reg.view
    # puts "SYSTEM TICK".cyan
    # puts self.class
    # puts (!@view.keys.include? self.class)
  end

end 
