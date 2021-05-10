class A
  def add_attribute name, value, access = true
    p name
    instance_variable_set("@#{name}", value)
    if access == true
      singleton_class.class_eval { attr_accessor name}
    end
  end
end
a = A.new
a.add_attribute(:speed, 10)
p a

def megainspect obj
  puts "Megainspecting: #{obj.class}"
  obj.instance_variables.each do |var|
    puts var
    puts "#{var}:\t\t\t#{obj.instance_variable_get("#{var}")}"
  end
end
Tools.megainspect a
