# palette:
def colorhex(str)
  color = []
  color << str[0..1].hex
  color << str[2..3].hex
  color << str[4..5].hex
end
Darkblue = colorhex('264653')
Green = colorhex('228B22')
Yellow = colorhex('e9c46a')
Orange = colorhex('f4a261')
Red = colorhex('e76f51')
Black = colorhex('000000')
White = colorhex('ffffff')
Brown = colorhex('8B4513')
Colors = [Darkblue,Green,Yellow,Orange,Red]

module Tools
  def self.normalize vector
    # expect [x,y]
    r = Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1])
    [vector[0]/r, vector[1]/r]
  end

  def self.megainspect obj
     puts "Megainspecting: #{obj.class}"
     obj.instance_variables.each do |var|
       puts "#{var}:\t\t\t#{obj.instance_variable_get("#{var}")}"
     end
  end

  def self.set_dir xform, dest_vector
    # expect dest_vector = [x,y]
    #xform = @container.xforms[@ent]
    x = dest_vector[0] - xform.x
    y = dest_vector[1] - xform.y
    norm = Tools.normalize([x,y])
    [norm[0],norm[1]]
  end
  
  # TODO - use or make an actual set class - but then again Hash#keys is array
  def self.subset? 
  end
end

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end
