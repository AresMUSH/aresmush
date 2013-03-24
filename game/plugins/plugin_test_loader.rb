require "aresmush"

def self.plugin_files(name = "*")
  dir = File.join(File.dirname(__FILE__), "*", "**", "*.rb")
  all_files = Dir[dir]  
  all_files.select { |f| !/_spec[s]*.rb*/.match(f) }
end

plugin_files.each do |f|
  load f
end
