module AresMUSH
  
  puts "======================================================================="
  puts "Converting completed scene logs and adding relationships."
  puts "======================================================================="
    
    
  Scene.all.each do |s|
    s.update(log: Scenes.convert_to_log(s))
  end

  Character.all.each do |c| 
    c.update(relationships: {})
    c.update(relationships_category_order: [])
  end    

  puts "Upgrade complete!"
end