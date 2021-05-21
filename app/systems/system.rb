class System
  attr_accessor :reads, :writes, :status

  def initialize
    @reads = []
    @writes = []
    @status = :enabled  # status can be  :enabled or :disabled
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

  def enable
    @status = :enabled
  end

  def disable
    @status = :disabled
  end

end 
