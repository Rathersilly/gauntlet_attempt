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

