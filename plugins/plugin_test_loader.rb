$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "engine"

def self.plugin_files(name = "*")
  dir = File.join(File.dirname(__FILE__), "**", "lib", "_load.rb")
  all_files = Dir[dir] 
  dir = File.join(File.dirname(__FILE__), "**", "engine", "_load.rb")
  all_files = all_files.concat Dir[dir] 
   
  all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
end

plugin_files.sort.each do |f|
  load f
end
