
puts "loading   " + Dir.glob("../*.rb").map{|file| File.basename(file)}.to_s

load_addins_file(Dir.glob("addin/addins/*.rb").map{|file| File.basename(file) })