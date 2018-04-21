module AresMUSH
  
  files = Dir["#{File.join(AresMUSH.game_path, "config")}/*"]
  files.each do |path|
    hash = YAML::load( File.read(path) )
    File.open(path, 'w') do |file|
      file.puts hash.to_yaml
    end
  end
  puts "Script complete!"
end