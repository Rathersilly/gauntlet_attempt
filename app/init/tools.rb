module Tools
  def self.normalize vector
    # expect [x,y]gt
    r = Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1])
    [vector[0]/r, vector[1]/r]
  end

  def self.megainspect obj
     puts "Megainspecting: #{obj.class}"
     obj.instance_variables.each do |var|
       puts "#{var}:\t\t\t#{obj.instance_variable_get("#{var}")}"
     end
  end
end

