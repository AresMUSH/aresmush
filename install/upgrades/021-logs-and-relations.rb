module AresMUSH
  
  puts "======================================================================="
  puts "Converting completed scene logs and adding relationships."
  puts "======================================================================="
    
    
  Scene.all.each do |s|
    s.update(log: Scenes.convert_to_log(s))
  end

  Character.all.each { |c| c.update(relationships: {})}

  puts "Upgrade complete!"
end