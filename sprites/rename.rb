# rename steelclads
#
fileregex = /steelclad-ne-run(\d+).png/

path = Dir.pwd + "/steelclad"
puts path
puts Dir.pwd
files = []
files2 = []
Dir.foreach(path) do |f|
  if f =~ fileregex
  files << f
    n = $1.to_i
    puts n
    n -= 1
    puts n
    puts "______"
    puts f
    puts f.gsub(/\d+/,n.to_s)
    files2 << f.gsub(/\d+/,n.to_s)

  end

end
p files.sort!
p files2.sort!

files.each.with_index do |f,i|
  if f =~ fileregex
    n = $1.to_i
    n -= 1
    File.rename(path + '/'+f,path + '/'+files2[i])
  end
end
