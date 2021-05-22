class System
  attr_accessor :reads, :writes, :enabled

  def initialize
    @reads = []
    @writes = []
    @enabled = true
  end
  def requirements
    @reads + @writes
  end

  def tick args, reg
    @reg = reg
    @view = reg.view
    # puts "SYSTEM TICK".cyan
    # puts self.class
    # puts (!@view.keys.include? self.class)
  end

  def enable
    @enabled = true
  end

  def disable
    @enabled = false
  end

  def enabled?
    @enabled == true
  end

  def disabled?
    @enabled == false
  end

end 
