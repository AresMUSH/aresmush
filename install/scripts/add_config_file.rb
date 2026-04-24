module AresMUSH

  name = ENV['ares_rake_param']
  if (!name)
    puts "You must specify a config file name."
    exit
  end  

  if (name.include?(".yml"))
    puts "Don't include .yml in the name you provide."
    exit
  end
  
  config_file_path = File.join(AresMUSH.game_path, "config", "#{name}.yml")
  if (File.exist?(config_file_path))
    puts "A config file with that name already exists. Choose a different name."
    exit
  end
  
  if (name !~ /^[a-z0-9]+$/)
    puts "Config file names may only contain lowercase letters and numbers."
    exit
  end
  
  File.open(File.join(AresMUSH.game_path, 'config', "#{name}.yml"), 'w') do |file|
    yaml = { name => { } }
    file.puts yaml.to_yaml
  end
  
  puts "\n****NOTE!**** You still need to do 'load config' in-game to update the game config.\n"
  puts "Script complete!"
end