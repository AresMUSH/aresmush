$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[engine]))

require 'fileutils'
require 'aresmush'


module AresMUSH
    
  puts "======================================================================="
  puts "Put the game dir back where it belongs."
  puts "======================================================================="

  secrets_path = File.join(AresMUSH.game_path, "config", "secrets.yml")
  FileUtils.mv secrets_path, File.join(AresMUSH.root_path, "game.backup", "secrets.yml")
  
  src = File.join(AresMUSH.root_path, "game.backup")
  if (Dir.exist?(src) && !Dir.exist?(AresMUSH.game_path))
    FileUtils.mv src, AresMUSH.game_path
  else
    puts "The game directory already exists.  Either you've already run this script or there are some leftover files you need to get rid of first.  Log files, aresconfig.js and ares.css can be safely deleted.  If you aren't sure what to do, ask for help on the forums."
  end
  
  puts "======================================================================="
  puts "Formatting config files."
  puts "======================================================================="
  
  files = Dir["#{File.join(AresMUSH.game_path, "config")}/*"]
  files.each do |path|
    hash = YAML::load( File.read(path) )
    File.open(path, 'w') do |file|
      file.puts hash.to_yaml
    end
  end
  
  puts "======================================================================="
  puts "Adding new default config options."
  puts "======================================================================="
  
  website_tagline = ""
  website_welcome = ""
  
  src = File.join(AresMUSH.game_path, "config", "website.yml")
  hash = YAML::load( File.read(src) )
  hash['website']['left_sidebar'] = false
  hash['website']['wiki_nav'] = [ 'Home' ]
  website_welcome = hash['website']['website_welcome']
  website_tagline = hash['website']['website_tagline']
  
  File.open(src, 'w') do |file|
    file.puts hash.to_yaml
  end
  
  src = File.join(AresMUSH.game_path, "config", "skin.yml")
  hash = YAML::load( File.read(src) )
  hash['skin']['line_with_text_color'] = '%x!'
  hash['skin']['line_with_text_padding'] = '-'
  File.open(src, 'w') do |file|
    file.puts hash.to_yaml
  end
  
  src = File.join(AresMUSH.game_path, "styles", "colors.scss")
  config = File.readlines(src)
  if (!config.any? { |c| c =~ /input/ })
    config << "$text-color: #333;"
    config << "$input-color: $text-color;"
    config << "$input-background-color: $background-color;"
  end
  File.open(src, 'w') do |file|
    file.puts config
  end
  
  src = File.join(AresMUSH.game_path, "text", "website.txt")
  File.open(src, 'w') do |file|
    file.puts "<div class=\"jumbotron-tagline\">#{website_tagline}</div>"
    file.puts website_welcome
  end
  
  puts "======================================================================="
  puts "Fixing gitignore."
  puts "======================================================================="
  
  src = File.join(AresMUSH.root_path, ".gitignore")
  lines = File.readlines(src)
  new_lines = []
  lines.each do |l|
    if (l.chomp != "game/")
      new_lines << l
    end
  end
  File.open(src, 'w') do |file|
    file.puts new_lines
  end
end