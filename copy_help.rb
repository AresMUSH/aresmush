require 'fileutils'
class String
  def titlecase
    self.downcase.strip.gsub(/\b('?[a-z])/) { $1.capitalize }
  end   
end

def plugin_title(name)
  return "AresCentral" if name == "arescentral"
  return "IC Time" if name == "ictime"
  return "OOC Time" if name == "ooctime"
  return "FS3 Skills" if name == "fs3skills"
  return "FS3 Combat" if name == "fs3combat"
  
  name.titlecase
end

version = File.readlines("game/version.txt").join

plugins = Dir['game/plugins/*']
plugin_names = []
plugins.each do |p|
  next if !File.directory?(p)
  plugin_name = File.basename(p)
  help_dir = "/Users/lynn/Documents/ares/help/#{plugin_name}"
  plugin_names << plugin_name
  if (!Dir.exist?(help_dir))
    Dir.mkdir help_dir
  end
  help_files = Dir["#{p}/help/*.md"]
  help_files.each do |h|
    FileUtils.copy h, "#{help_dir}/#{File.basename(h)}"
  end
end


File.open("/Users/lynn/Documents/ares/ares/partials/plugin_list.md", 'w') do |file|
  file.puts "*AresMUSH version #{version}*"
  file.puts ""
  plugin_names.each do |p|
    file.puts "* [#{plugin_title(p)}](/help/#{p})"
  end
end
