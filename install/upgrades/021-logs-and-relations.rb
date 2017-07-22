module AresMUSH
  
  puts "======================================================================="
  puts "Converting completed scene logs and adding relationships."
  puts "======================================================================="
    
    
  Scene.all.each do |s|
    if (s.shared)
      log = SceneLog.create(scene: s, log: Scenes.build_log_text(s))
      s.update(scene_log: log)
    end    
  end

  Character.all.each do |c| 
    c.update(relationships: {})
    c.update(relationships_category_order: [])
  end    

  puts "Upgrade complete!"
end