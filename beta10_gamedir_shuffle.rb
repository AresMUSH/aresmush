$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[engine]))

require 'fileutils'
require 'aresmush'


module AresMUSH
    
  puts "======================================================================="
  puts "Put the game dir back where it belongs."
  puts "======================================================================="

#  src = File.join(AresMUSH.root_path, "game.backup")
#  if (Dir.exist?(src))
#    FileUtils.mv src, AresMUSH.game_path
#  end
  
  puts "======================================================================="
  puts "Formatting config files."
  puts "======================================================================="
  
#  files = Dir["#{File.join(AresMUSH.game_path, "config")}/*"]
#  files.each do |path|
#    hash = YAML::load( File.read(path) )
#    File.open(path, 'w') do |file|
#      file.puts hash.to_yaml
#    end
#  end
  
  puts "======================================================================="
  puts "Adding new default config options."
  puts "======================================================================="
  
#  website_tagline = ""
#  website_welcome = ""
  
#  src = File.join(AresMUSH.game_path, "config", "website.yml")
#  hash = YAML::load( File.read(src) )
#  hash['website']['left_sidebar'] = false
#  hash['website']['wiki_nav'] = [ 'Home' ]
#  website_welcome = hash['website']['website_welcome']
#  website_tagline = hash['website']['website_tagline']
  
#  File.open(src, 'w') do |file|
#    file.puts hash.to_yaml
#  end
  
#  src = File.join(AresMUSH.game_path, "config", "skin.yml")
#  hash = YAML::load( File.read(src) )
#  hash['skin']['line_with_text_color'] = '%x!'
#  hash['skin']['line_with_text_padding'] = '-'
#  File.open(src, 'w') do |file|
#    file.puts hash.to_yaml
#  end
  
  src = File.join(AresMUSH.game_path, "styles", "colors.scss")
  config = File.readlines(src)
  if (config !~ /input/)
    config << "$text-color: #333;"
    config << "$input-color: $text-color;"
    config << "$input-background-color: $background-color;"
  end
  File.open(src, 'w') do |file|
    file.puts config
  end
  
#  src = File.join(AresMUSH.game_path, "text", "website.txt")
#  File.open(src, 'w') do |file|
#    file.puts "<div class=\"jumbotron-tagline\">#{website_tagline}</div>"
#    file.puts website_welcome
#  end
  
  
  
end